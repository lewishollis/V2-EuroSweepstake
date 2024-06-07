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

# Create friends and associate them with groups
friend1 = Friend.create!(name: "Lewis")
friend2 = Friend.create!(name: "Claire")

# Create groups first
group1 = Group.create!(name: "Group A", multiplier: 3, friend: friend1)
group2 = Group.create!(name: "Group B", multiplier: 2, friend: friend2)


# Create teams
team1 = Team.create!(name: "Italy")
team2 = Team.create!(name: "Germany")
team3 = Team.create!(name: "France")
team4 = Team.create!(name: "Spain")

# Assign teams to groups
group1.teams << team1
group1.teams << team2
group2.teams << team3
group2.teams << team4

puts "Seed data has been successfully created."
