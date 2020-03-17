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
