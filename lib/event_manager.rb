puts 'Event Manager Initialized!'

# check if file exists
puts(File.exist? 'event_attendees.csv')

# read csv file contents
contents = File.read('event_attendees.csv')
# puts contents

# save lines into array then output contents of each line
lines = File.readlines('event_attendees.csv')

=begin
lines.each do |line|
  puts line
end 

# Display first name of all attendees

lines.each do |line|
  columns = line.split(",")
  name = columns[2]
  puts name
end 
=end

# Skip header row 

=begin
row_index = 0

 lines.each do |line|
  row_index += 1

  next if row_index == 1
  columns = line.split(",")
  name = columns[2]
  puts name
end 
=end 

# Second option

lines.each_with_index do |line,index|
  next if index == 0
  columns = line.split(",")
  name = columns[2]
  puts name
end

# Iteration 1: Parsing with CSV

