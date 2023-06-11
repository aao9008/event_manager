require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'
require 'date'

puts 'Event Manager Initialized!'

puts Dir.pwd

Dir.chdir '/Users/alfredo.ormeno/repos/event_manager'

puts Dir.pwd

# check if file exists
puts(File.exist? 'event_attendees.csv')

def phone_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

# Returns comma seprated list of legislator names
def legislators_by_zipcode(zipcode)
  # generate new api service request
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  # generate key from google api credentials site
  civic_info.key = 'AIzaSyChbPur00E7zrTcqIpAjytLocQUwnuMaB4'

  # use exception class to rescue a bad zip code query request
  begin
    legislators = civic_info.representative_info_by_address(address: zipcode, levels: 'country', roles: ['legislatorUpperBody', 'legislatorLowerBody']).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thankyou_letter(id, form_letter)
  # create folder for custom form letters if folder does not exist
  Dir.mkdir('output') unless Dir.exist?('output')

  # Create file for each attendee, ID value identifies attendee
  filename = "output/thanks_#{id}.html"

  # Create and open new file for attendee
  File.open(filename, 'w') do |file|
    # copt erb output to custom form letter file 
    file.puts form_letter
  end
end

def clean_phone_number(phone_number)
  phone_number = phone_number.delete("^0-9")
  if phone_number.length == 10
    phone_number
  elsif phone_number.length == 11
    phone_number[1..10] if phone_number[0].to_i == 1
  else
    "Bad Number!"
  end
end

def most_common_hour
  # Open CSV file
  contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)
  # This array will hold registration hours 
  reg_hour_array = []

  # Read registration dates from CSV file 
  contents.each do |row|
    # Get reg date and time 
    reg_date = row[:regdate]

    # Create time object from string and then get hour from time object 
    reg_hour = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%k')

    # Store registration hour in array 
    reg_hour_array.push(reg_hour)
  end

  reg_hour_counts = reg_hour_array.reduce(Hash.new(0)) do |hash, hour| 
    hash[hour] += 1
    
    hash
  end 

  peak_hour = reg_hour_counts.max_by { |k, value| value}[0]
end

def most_common_reg_day 
  # Open CSV file 
  contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

  # Array will hold what day of the week people regsitered on
  reg_day_array = []

  # Read registration date from CSV file
  contents.each do |row|
    # Get the registration date
    reg_day = row[:regdate]

    # parse registration date to a time object and then get day of the week from time object
    reg_day = Time.strptime(reg_day, '%M/%d/%y %k:%M').strftime('%A')

    # Store day of the week in the reg_day_array 
    reg_day_array.push(reg_day)
  end

  # Enumerate over array to get most common registration day
  reg_day_counts = reg_day_array.reduce(Hash.new(0)) do |hash, day|
    hash[day] += 1
    hash
  end 

  peak_reg_day = reg_day_counts.max_by{|key, value| value}[0]
end 


# Open CSV file
contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = phone_zipcode(row[:zipcode])

  phone_number = clean_phone_number(row[:homephone])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thankyou_letter(id, form_letter)
end

puts "\nThe most common hour of registration is: #{most_common_hour}:00"

puts "\nThe most common registration day is: #{most_common_reg_day}"
