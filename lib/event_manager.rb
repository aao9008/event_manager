require 'csv'
require 'google/apis/civicinfo_v2'

puts 'Event Manager Initialized!'

puts Dir.pwd

Dir.chdir '/Users/alfredo.ormeno/repos/event_manager'

puts Dir.pwd

# check if file exists
puts(File.exist? 'event_attendees.csv')

def clean_zipcode(zipcode)
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
    legislators = civic_info.representative_info_by_address(address: zipcode, levels: 'country', roles: ['legislatorUpperBody', 'legislatorLowerBody'])

    legislators = legislators.officials

    # Use map function to tranform data in legislator object to dispay array of legislator names
    legislator_names = legislators.map(&:name)

    # Create comma seperate list from array to cleanly display names
    legislators_string = legislator_names.join(", ")
  rescue
    puts 'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

# Open CSV file
contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
end
