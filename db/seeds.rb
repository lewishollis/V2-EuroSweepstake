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
group1 = Group.create!(name: "Group A", multiplier: 3)
group2 = Group.create!(name: "Group B", multiplier: 2)
# Create more groups as needed

# Create friends and associate them with groups
friend1 = Friend.create!(name: "Lewis", group: group1)
friend2 = Friend.create!(name: "Claire", group: group2)
# Create more friends as needed

# Update groups with the corresponding friend_id
group1.update!(friend_id: friend1.id)
group2.update!(friend_id: friend2.id)

# Create teams
team1 = Team.create!(name: "Italy")
team2 = Team.create!(name: "Germany")
team3 = Team.create!(name: "France")
team4 = Team.create!(name: "Spain")
# Create more teams as needed

# Assign teams to groups
group1.teams << team1
group1.teams << team2
group2.teams << team3
group2.teams << team4
# Assign more teams to groups as needed

puts "Seed data has been successfully created."
