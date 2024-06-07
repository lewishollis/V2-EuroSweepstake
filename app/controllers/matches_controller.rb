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

            match = Match.new(
              home_team: home_team,
              away_team: away_team,
              home_score: event['home']['score'].to_i,
              away_score: event['away']['score'].to_i,
              start_time: event['date']['iso'],
              status: event['status'],
              winner: event['winner'],
              accessible_event_summary: event['accessibleEventSummary']
            )

            match.save!
            @matches << match
          end
        end
      end
    else
      @error_message = "Failed to fetch match data: #{response.code} - #{response.message}"
    end
  end
end
