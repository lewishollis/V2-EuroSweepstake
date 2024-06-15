require 'net/http'

class MatchesController < ApplicationController
  def index
    today_date = Time.now.strftime("%Y-%m-%d")
    url = URI("https://web-cdn.api.bbci.co.uk/wc-poll-data/container/sport-data-scores-fixtures?selectedEndDate=2024-06-30&selectedStartDate=2024-06-14&todayDate=#{today_date}&urn=urn%3Abbc%3Asportsdata%3Afootball%3Atournament%3Aeuropean-championship&useSdApi=false")

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

            # Fetching home and away friend names and profile picture URLs
            home_friend = home_team.groups.first&.friend
            away_friend = away_team.groups.first&.friend

            home_friend_profile_picture_url = home_friend.profile_picture_url if home_friend.present?
            away_friend_profile_picture_url = away_friend.profile_picture_url if away_friend.present?

            home_friend_name = home_friend&.name || 'No owner'
            away_friend_name = away_friend&.name || 'No owner'

            stage = event['stage'] || { 'name' => 'Unknown Stage' }

            # Determine if match is live
            if event['status'] == 'MidEvent'
              winner = nil  # Set winner to nil if match is in progress
            else
              winner = event['winner']  # Set winner if match is finished
            end

            # Modify match initialization to include status and live scores
            match = Match.find_or_initialize_by(match_id: event['id'])
            match.assign_attributes(
              home_team: home_team,
              away_team: away_team,
              start_time: event['date']['iso'],
              match_id: event['id'],
              stage: stage['name'],
              home_friend_name: home_friend_name,
              away_friend_name: away_friend_name,
              home_friend_profile_picture_url: home_friend_profile_picture_url,
              away_friend_profile_picture_url: away_friend_profile_picture_url,
              home_score: event['home']['score'].to_i,
              away_score: event['away']['score'].to_i,
              status: event['status'],
              winner: winner,  # Assign winner based on match status
              accessible_event_summary: event['accessibleEventSummary']
            )

            if match.new_record?
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

    stage = match.stage

    case stage
    when 'Group Stage'
      match.home_points = 0
      match.away_points = 0
      puts "Group Stage match. No points awarded."
    when 'Last 16', 'Quarter Final', '3rd Place Final'
      if match.winner == 'home'
        match.home_points = 1
        match.away_points = 0
        puts "Home team wins #{stage}. Home points: #{match.home_points}, Away points: #{match.away_points}"
      elsif match.winner == 'away'
        match.home_points = 0
        match.away_points = 1
        puts "Away team wins #{stage}. Home points: #{match.home_points}, Away points: #{match.away_points}"
      else
        match.home_points = 0
        match.away_points = 0
        puts "Draw in #{stage}. Home points: #{match.home_points}, Away points: #{match.away_points}"
      end
    when 'Final'
      if match.winner == 'home'
        match.home_points = 2
        match.away_points = 1
        puts "Home team wins Final. Home points: #{match.home_points}, Away points: #{match.away_points}"
      elsif match.winner == 'away'
        match.home_points = 1
        match.away_points = 2
        puts "Away team wins Final. Home points: #{match.home_points}, Away points: #{match.away_points}"
      else
        match.home_points = 0
        match.away_points = 0
        puts "Draw in Final. Home points: #{match.home_points}, Away points: #{match.away_points}"
      end
    else
      match.home_points = 0
      match.away_points = 0
      puts "Unknown stage. No points awarded. Stage: #{stage}"
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
