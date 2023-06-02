require 'csv'

puts 'Event Manager Initialized!'

# check if file exists
puts(File.exist? 'event_attendees.csv')

=begin
# read csv file contents
contents = File.read('event_attendees.csv')
# puts contents

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


# Skip header row 


row_index = 0

 lines.each do |line|
  row_index += 1

  next if row_index == 1
  columns = line.split(",")
  name = columns[2]
  puts name
end 


# Second option

lines.each_with_index do |line,index|
  next if index == 0
  columns = line.split(",")
  name = columns[2]
  puts name
end
=end

# Iteration 1: Parsing with CSV

# Use Ruby CSV parser to access attendees' zip code.

contents = CSV.open('event_attendees.csv', headers: true)

=begin
contents.each do |row|
  name = row[2]
  puts name
end 
=end

# Accessing Columns by their Names

contents = CSV.open('event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

=begin
contents.each do |row|
  name = row[:first_name]
  puts name
end
=end

# Displaying the Zip Codes of All Attendees

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end