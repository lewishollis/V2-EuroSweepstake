# app/controllers/matches_controller.rb
class MatchesController < ApplicationController
  def index
    url = URI("https://web-cdn.api.bbci.co.uk/wc-poll-data/container/sport-data-scores-fixtures?selectedEndDate=2021-07-11&selectedStartDate=2021-06-14&todayDate=2024-06-05&urn=urn%3Abbc%3Asportsdata%3Afootball%3Atournament%3Aeuropean-championship&useSdApi=false")
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

            match = Match.find_or_initialize_by(
              home_team: home_team,
              away_team: away_team,
              start_time: event['date']['iso']
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
      match.home_points = 3
      match.away_points = 0
      puts "Home team wins. Home points: #{match.home_points}, Away points: #{match.away_points}"
    elsif match.winner == 'away'
      match.home_points = 0
      match.away_points = 3
      puts "Away team wins. Home points: #{match.home_points}, Away points: #{match.away_points}"
    else
      match.home_points = 1
      match.away_points = 1
      puts "Draw. Home points: #{match.home_points}, Away points: #{match.away_points}"
    end

    # Update team points
    update_team_points(match.home_team, match.home_points)
    update_team_points(match.away_team, match.away_points)
  end

  def update_team_points(team, points)
    team.points = (team.points || 0) + points
    team.save!
  end
end
