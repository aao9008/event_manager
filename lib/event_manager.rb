require 'csv'

puts 'Event Manager Initialized!'

puts Dir.pwd

Dir.chdir '/Users/alfredo.ormeno/repos/event_manager'

puts Dir.pwd

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
=begin
contents = CSV.open('event_attendees.csv', headers: true)


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
=begin
contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]

  # Iteration 2: Cleaning up our Zip Codes

  # if the zip code is exactly five digits, assume that it is okay, so do nothing

  # if the zip code is less than five digits, add zeros to the front until it becomes five digits
  if zipcode.nil?
    zipcode = '00000'
  elsif  zipcode.length < 5
    zipcode = zipcode.rjust(5, '0')

  # if the zip code is more than five digits, truncate it to the first five digits.
  elsif zipcode.length > 5
    zipcode = zipcode[0,5]
  end

  puts "#{name} #{zipcode}"
end
=end

=begin Move clean zip code to its own method 
def clean_zipcode(zipcode)
  if zipcode.nil?
    zipcode = '00000'
  elsif  zipcode.length < 5
    zipcode = zipcode.rjust(5, '0')

  # if the zip code is more than five digits, truncate it to the first five digits.
  elsif zipcode.length > 5
    zipcode = zipcode[0, 5]
  else
    zipcode
  end
end


contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  puts "#{name} #{zipcode}"
end
=end

# Refactoring clean_zipcodes
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  puts "#{name} #{zipcode}"
end
