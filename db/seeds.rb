# db/seeds.rb

# Delete all records to ensure a clean slate
puts "Deleting all records..."

# Delete all associations first to avoid foreign key constraints issues
Group.all.each { |group| group.teams.clear }

# Then delete the records themselves
Friend.destroy_all
Team.destroy_all
Group.destroy_all
FriendsGroup.destroy_all
FriendGroupTeam.destroy_all
Match.destroy_all

puts "All records deleted."

# Create friends
friend_names = [
  "Lewis", "Claire", "Craig", "Emma", "Sam", "Ella",
  "Richard", "Nhien", "Matt", "Jamie", "Ben", "Aimee"
]

friends = friend_names.map { |name| Friend.create!(name: name) }

# Create teams
team_names = ["Italy", "Germany", "France", "Spain", "Portugal", "Netherlands",
              "Belgium", "Denmark", "Sweden", "England", "Croatia", "Switzerland"]

teams = team_names.map { |name| Team.create!(name: name) }

# Define group details including friends, multipliers, and teams
group_details = [
  { name: "Group 1", friend: "Lewis", multiplier: 2.5, teams: ["Italy", "Germany"] },
  { name: "Group 2", friend: "Claire", multiplier: 1.5, teams: ["France", "Spain"] },
  { name: "Group 3", friend: "Craig", multiplier: 3.0, teams: ["Portugal", "Netherlands"] },
  { name: "Group 4", friend: "Emma", multiplier: 2.0, teams: ["Belgium", "Denmark"] },
  { name: "Group 5", friend: "Sam", multiplier: 1.8, teams: ["Sweden", "England"] },
  { name: "Group 6", friend: "Ella", multiplier: 2.2, teams: ["Croatia", "Switzerland"] },
  { name: "Group 7", friend: "Richard", multiplier: 2.7, teams: ["Italy", "Portugal"] },
  { name: "Group 8", friend: "Nhien", multiplier: 1.9, teams: ["Germany", "France"] },
  { name: "Group 9", friend: "Matt", multiplier: 2.4, teams: ["Spain", "Belgium"] },
  { name: "Group 10", friend: "Jamie", multiplier: 2.1, teams: ["Netherlands", "Sweden"] },
  { name: "Group 11", friend: "Ben", multiplier: 2.6, teams: ["England", "Croatia"] },
  { name: "Group 12", friend: "Aimee", multiplier: 1.7, teams: ["Denmark", "Switzerland"] }
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
