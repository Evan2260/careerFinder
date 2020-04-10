require 'nokogiri'
require 'httparty'
require 'pry'

#Remember to run chruby 2.6.5

def scraper
  url = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&fromage=last&sort=date"

  page_content = HTTParty.get(url)

  parsed_content = Nokogiri::HTML(page_content)

  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')

  job_info = {
    "Company" => [],
    "Role" => []
  }

  job_title = job_listings.css('div.title').map do |x|
    position = x.text.strip
    job_info["Role"].push(position)
  end

  company_names = job_listings.css('span.company').map do |x|
    position = x.text.strip
    job_info["Company"].push(position)
  end

  json = JSON.pretty_generate(job_info)

  File.open('jobData.json', 'w') { |file| file.write(json)}


end
scraper

# class Job < ApplicationRecord
#   validates :role, presence: true
#   validates :company, presence: true
# end
# #------- Hannah's seed.rb file -----------------------
# ballots = CountryScraper.scrape_for_states
# Ballot.create_from_collection(ballots)
# #-----------------------------------------------------
# class CountryScraper
#     STATES = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Florida", "Hawaii", "Idaho", "Illinois", "Iowa", "Kentucky", "Louisiana", "Maine", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "South Dakota", "Utah", "Virginia", "Washington", "Wisconsin", "Wyoming"]
#
#   def self.scrape_for_states
#     ballots = []
#     STATES.each do |state|
#       new_state = State.create(name: state)
#       ballots << StateScraper.new(new_state).scrape_for_state
#     end
#     ballots
#   end
# end
#
# class Ballot < ApplicationRecord
#   validates :name, presence: true
#   validates :description, presence: true
#   validates :subject, presence: true
#
#   belongs_to :state
#   has_many :events
#
#   def self.create_from_collection(ballots)
#     ballots.each do |hash_array|
#       hash_array.each do |hash|
#         Ballot.create(state: hash[:state], name: hash[:name], subject: hash[:subject], description: hash[:description])
#       end
#     end
#   end
# end
#
#
# class State < ApplicationRecord
#   validates :name, presence: true
#
#   has_many :ballots
# end
#
# class StateScraper
#   attr_reader :state, :url
#   BASE_URL = "https://ballotpedia.org"
#
#   def initialize(state)
#     @state = state
#     @url = "#{BASE_URL}/#{state.name}_2020_ballot_measures".sub(" ", "_")
#     @ballot_array = []
#   end
#
#   def scrape_for_state
#     parse_ballots(request_state_ballots)
#     determine_scraper
#     create_ballot_hash
#   end
#
#    private
#
#   def request_state_ballots
#     return open(url)
#   end
#
#   def parse_ballots(response_data)
#     @doc = Nokogiri::HTML(request_state_ballots)
#   end
#
#   def determine_scraper
#     single_table = @doc.css('.bptable')[0]
#     two_tables = @doc.css('.bptable')[0..1]
#     case @state.name
#     when "California"
#       tables = @doc.css('.bptable')[0..5]
#       scrape_for_california(tables)
#     when "Massachusetts"
#       scrape_for_massachusetts(single_table)
#     when "Colorado", "Missouri", "Oregon"
#       scrape_for_colorado_or_missouri_or_oregon(two_tables)
#     when "Arkansas", "Alabama", "Maine", "Michigan", "Montana", "Nebraska", "Nevada", "North Dakota", "Oklahoma", "Utah", "Wyoming"
#       scrape_for_states_cluster(two_tables)
#     else
#       scrape_remaining_states(single_table)
#     end
#   end
#
#   def scrape_for_states_cluster(two_tables)
#     two_tables.collect do |table|
#       rows = table.css('tr')[1..-1]
#         rows.each do |row|
#           name = row.css('td')[1].text.strip
#           subject = row.css('td')[2].text.strip
#           description = row.css('td')[3].text.strip
#           @ballot_array << [name, subject, description]
#         end
#     end
#   end
#
#   def scrape_for_colorado_or_missouri_or_oregon(two_tables)
#     two_tables.collect do |table|
#       rows = table.css('tr')[1..-1]
#       rows.each do |row|
#         if table.css('tr')[0].css('th')[1].text.strip == 'Title'
#           name = row.css('td')[1].text.strip
#           subject = row.css('td')[2].text.strip
#           description = row.css('td')[3].text.strip
#           @ballot_array << [name, subject, description]
#         else
#           name = row.css('td')[2].text.strip
#           subject = row.css('td')[3].text.strip
#           description = row.css('td')[4].text.strip
#           @ballot_array << [name, subject, description]
#         end
#       end
#     end
#   end
#
#   def scrape_for_massachusetts(single_table)
#     rows = single_table.css('tr')[1..-1]
#     rows.collect do |row|
#       name = row.css('td')[2].text.gsub('"','')
#       subject = row.css('td')[3].text.strip
#       description = row.css('td')[4].text.strip
#       @ballot_array << [name, subject, description]
#     end
#   end
#
#   def scrape_for_california(tables)
#     tables.collect do |table|
#       if table.css('tr')[0].css('th')[0].text.strip != 'Ballot Measure:'
#         rows = table.css('tr')[1..-1]
#         rows.each do |row|
#           if table.css('tr')[0].css('th')[1].text.strip == 'Title'
#             name = row.css('td')[1].text.strip
#             subject = row.css('td')[2].text.strip
#             description = row.css('td')[3].text.strip
#             @ballot_array << [name, subject, description]
#           else
#             name = row.css('td')[1].text.strip
#             subject = "unspecified"
#             description = row.css('td')[2].text.strip
#             @ballot_array << [name, subject, description]
#           end
#         end
#       end
#     end
#   end
#
#   def scrape_remaining_states(single_table)
#     rows = single_table.css('tr')[1..-1]
#     rows.collect do |row|
#       name = row.css('td')[1].text.strip
#       subject = row.css('td')[2].text.strip
#       description = row.css('td')[3].text.strip
#       @ballot_array << [name, subject, description]
#     end
#   end
#
#   def create_ballot_hash
#     ballots = []
#     @ballot_array.each do |ballot|
#       name = ballot[0]
#       subject = ballot[1]
#       description = ballot[2]
#       ballot_info = {
#         state: @state,
#         name: name,
#         subject: subject,
#         description: description
#       }
#
#       ballots << ballot_info
#     end
#     ballots
#   end
#
# end
