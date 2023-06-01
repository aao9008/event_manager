puts 'Event Manager Initialized!'

# check if file exists
puts(File.exist? 'event_attendees.csv')

# read csv file contents
contents = File.read('event_attendees.csv')
puts contents

# save lines into array then output contents of each line
lines = File.readlines('event_attendees.csv')

lines.each do |line|
  puts line
end 

# Display first name of all attendees

lines.each do |line|
  columns = line.split(",")
  name = columns[2]
  puts name
end 

