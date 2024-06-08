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

# Create groups
groups = []
(1..12).each do |i|
  groups << Group.create!(name: "Group #{i}", multiplier: rand(1.0..3.0))
end

# Create friends
friend_names = [
  "Lewis", "Claire", "Craig", "Emma", "Sam", "Ella",
  "Richard", "Nhien", "Matt", "Jamie", "Alex", "Taylor"
]

friends = friend_names.map { |name| Friend.create!(name: name) }

# Assign friends to groups
groups.each_with_index do |group, index|
  group.update!(friend: friends[index])
end

# Create teams
team_names = ["Italy", "Germany", "France", "Spain", "Portugal", "Netherlands",
              "Belgium", "Denmark", "Sweden", "England", "Croatia", "Switzerland"]

teams = team_names.map { |name| Team.create!(name: name) }

# Assign teams to groups
groups.each_with_index do |group, index|
  group.teams << teams[index % teams.length]
  group.teams << teams[(index + 1) % teams.length]
end

puts "Seed data has been successfully created."
