require 'nokogiri'
require 'httparty'
require 'pry'

#Remember to run chruby 2.6.5

def scraper
  url = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&fromage=last&sort=date"

  page_content = HTTParty.get(url)

  parsed_content = Nokogiri::HTML(page_content)

  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')

  position_array = []

  job_title = job_listings.css('div.title').map do |x|
    position = x.text.strip
    position_array.push(position)
  end

  position_hash = {}

  position_array.each do |y|
    position_hash["Roles"] = position_array
  end

# binding.pry

  json = JSON.pretty_generate(position_hash)

  File.open('jobData.json', 'w') { |file| file.write(json)}


end
scraper


#try using gsub to Globally substitute all "\n" with
