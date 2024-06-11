require 'net/http'

class MatchesController < ApplicationController
  def index
    url = URI("https://web-cdn.api.bbci.co.uk/wc-poll-data/container/sport-data-scores-fixtures?selectedEndDate=2022-12-18&selectedStartDate=2022-11-20&todayDate=2024-06-10&urn=urn%3Abbc%3Asportsdata%3Afootball%3Atournament%3Aworld-cup&useSdApi=false")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["accept"] = 'application/json'

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      @matches = []

      data['eventGroups'].each do |event_group|
        event_group['secondaryGroups'].each do |secondary_group|
          secondary_group['events'].each do |event|
            home_team = Team.find_or_create_by(name: event['home']['fullName'])
            away_team = Team.find_or_create_by(name: event['away']['fullName'])

            # Modify to include match_id
            match = Match.find_or_initialize_by(match_id: event['id'])
            match.assign_attributes(
              home_team: home_team,
              away_team: away_team,
              start_time: event['date']['iso'],
              match_id: event['id'] # Assigning the match ID here
            )

            if match.new_record?
              match.assign_attributes(
                home_score: event['home']['score'].to_i,
                away_score: event['away']['score'].to_i,
                status: event['status'],
                winner: event['winner'],
                accessible_event_summary: event['accessibleEventSummary']
              )

              assign_points(match)
              match.save!
            end

            @matches << match
          end
        end
      end
    else
      @error_message = "Failed to fetch match data: #{response.code} - #{response.message}"
    end
  end

  private

  def assign_points(match)
    puts "Assigning points for match: #{match.inspect}"

    if match.winner == 'home'
      match.home_points = 1
      match.away_points = 0
      puts "Home team wins. Home points: #{match.home_points}, Away points: #{match.away_points}"
    elsif match.winner == 'away'
      match.home_points = 0
      match.away_points = 1
      puts "Away team wins. Home points: #{match.home_points}, Away points: #{match.away_points}"
    else
      match.home_points = 0
      match.away_points = 0
      puts "Draw. Home points: #{match.home_points}, Away points: #{match.away_points}"
    end

    update_team_points(match.home_team, match.home_points)
    update_team_points(match.away_team, match.away_points)
  end

  def update_team_points(team, points)
    puts "Updating team points: Team: #{team.name}, Current Points: #{team.points}, Points to Add: #{points}"
    team.points = (team.points || 0) + points
    team.save!
    puts "New team points: Team: #{team.name}, Updated Points: #{team.points}"
  end
end
