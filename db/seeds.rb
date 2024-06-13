# db/seeds.rb

# Create friends
friend_data = [
  { name: "Lewis", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Lewis.jpeg') },
  { name: "Claire", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Claire.jpeg') },
  { name: "Craig", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Craig.jpeg') },
  { name: "Emma", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Emma.jpeg') },
  { name: "Sam", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Sam.jpeg') },
  { name: "Ella", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Ella.jpeg') },
  { name: "Richard", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Richard.jpeg') },
  { name: "Nhien", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Nhien.jpeg') },
  { name: "Matt", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Matt.jpeg') },
  { name: "Ben", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Ben.jpeg') },
  { name: "Aimee", profile_picture_url: ActionController::Base.helpers.asset_path('images-ben/Aimee.jpeg') }
]

friends = friend_data.map { |data| Friend.create!(data) }

# Create teams
team_names = [
  "Germany", "Scotland", "Hungary", "Switzerland",
  "Spain", "Croatia", "Italy", "Albania",
  "Slovenia", "Denmark", "Serbia", "England",
  "Poland", "Netherlands", "Austria", "France",
  "Belgium", "Slovakia", "Romania", "Ukraine",
  "Turkey", "Georgia", "Portugal", "Czech Republic"
]

teams = team_names.map { |name| Team.create!(name: name) }

# Define group details including friends, multipliers, and teams
group_details = [
  { name: "Group 1", friend: "Aimee", multiplier: 10, teams: ["Spain", "Turkey", "France", "Belgium"] },
  { name: "Group 2", friend: "Ben", multiplier: 10, teams: ["Germany", "Albania", "Ukraine", "Scotland"] },
  { name: "Group 3", friend: "Claire", multiplier: 7, teams: ["Hungary", "Czech Republic"] },
  { name: "Group 4", friend: "Craig", multiplier: 9, teams: ["Switzerland", "Netherlands", "Austria"] },
  { name: "Group 5", friend: "Ella", multiplier: 9, teams: ["Croatia", "Serbia", "Denmark"] },
  { name: "Group 6", friend: "Emma", multiplier: 10, teams: ["Portugal", "Romania", "Poland", "Italy"] },
  { name: "Group 7", friend: "Lewis", multiplier: 9, teams: ["Slovakia", "Slovenia", "Georgia"] },
  { name: "Group 8", friend: "Nhien", multiplier: 9, teams: ["England", "Turkey", "Spain"] },
  { name: "Group 9", friend: "Richard", multiplier: 8, teams: ["France", "Wales"] },
  { name: "Group 10", friend: "Sam", multiplier: 7, teams: ["Ukraine", "Belgium"] },
  { name: "Group 11", friend: "Matt", multiplier: 8, teams: ["Portugal", "Denmark"] },
]

# Create groups and assign details
group_details.each do |details|
  friend = friends.find { |f| f.name == details[:friend] }
  group = Group.create!(name: details[:name], multiplier: details[:multiplier], friend: friend)

  details[:teams].each do |team_name|
    team = teams.find { |t| t.name == team_name }
    group.teams << team if team
  end
end

puts "Seed data has been successfully created."
