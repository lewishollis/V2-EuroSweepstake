# db/seeds.rb


# Create friends
friend_names = [
  "Lewis", "Claire", "Craig", "Emma", "Sam", "Ella",
  "Richard", "Nhien", "Matt", "Jamie", "Ben", "Aimee"
]

friends = friend_names.map { |name| Friend.create!(name: name) }

# Create teams
#team_names = ["Italy", "Germany", "France", "Spain", "Portugal", "Netherlands",
 #             "Belgium", "Denmark", "Sweden", "England", "Croatia", "Switzerland"]

team_names = ["Croatia", "Serbia", "South Korea", "United States", "Canada", "Germany", "Ghana", "Iran", "Brazil",
   "Tunisia", "Netherlands", "Saudi Arabia", "Senegal", "Ecuador", "Japan", "Costa Rica", "Mexico", "Poland", "Qatar",
    "Wales", "Argentina", "Cameroon",  "Italy", "Germany", "France", "Spain", "Portugal", "Netherlands",
               "Belgium", "Denmark", "Sweden", "England", "Switzerland", "Morocco", "Australia", "Uruguay"]

teams = team_names.map { |name| Team.create!(name: name) }

# Define group details including friends, multipliers, and teams
group_details = [
  { name: "Group 1", friend: "Aimee", multiplier: 10, teams: ["Croatia", "Serbia", "South Korea", "United States"] },
  { name: "Group 2", friend: "Ben", multiplier: 10, teams: ["Canada", "Germany", "Ghana", "Iran"] },
  { name: "Group 3", friend: "Claire", multiplier: 7, teams: ["Brazil", "Tunisia"] },
  { name: "Group 4", friend: "Craig", multiplier: 9, teams: ["Netherlands", "Saudi Arabia", "Senegal"] },
  { name: "Group 5", friend: "Ella", multiplier: 9, teams: ["Ecuador", "Japan", "Portugal"] },
  { name: "Group 6", friend: "Emma", multiplier: 10, teams: ["Costa Rica", "Mexico", "Switzerland", "Uruguay"] },
  { name: "Group 7", friend: "Lewis", multiplier: 9, teams: ["Poland", "Morocco", "Spain"] },
  { name: "Group 8", friend: "Nhien", multiplier: 9, teams: ["Belgium", "Denmark", "Qatar"] },
  { name: "Group 9", friend: "Richard", multiplier: 8, teams: ["France", "Wales"] },
  { name: "Group 10", friend: "Sam", multiplier: 7, teams: ["Argentina", "Cameroon"] },
  { name: "Group 11", friend: "Matt", multiplier: 8, teams: ["England", "Australia"] },
  #{ name: "Group 12", friend: "Aimee", multiplier: 1.7, teams: ["Denmark", "Switzerland"] }
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
