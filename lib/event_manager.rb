require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

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


# Open CSV file
contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thankyou_letter(id, form_letter)
end
