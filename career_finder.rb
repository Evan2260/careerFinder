require 'nokogiri'
require 'httparty'
require 'pry'

#Remember to run chruby 2.6.5
# Data needed:
# - company
# - position/Role
# - Location
# - Summary
# - salary

# pineco
# steelix

def scraper
  url = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&fromage=last&sort=date"
  page_content = HTTParty.get(url)
  parsed_content = Nokogiri::HTML(page_content)
  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')
  # specific_job_listings = parsed_content.css('div.sjcl')

  job_company = job_listings.css('span.company')
  job_role = job_listings.css('h2.title')
  job_location = job_listings.css('span.accessible-contrast-color-location')
  job_salary = job_listings.css('span.salaryText')

  jobs = Array.new

  job_listings.each do |element|
    job = {
      company: element.css('span.company').text,
      position: element.css('h2.title').text,
      location: element.css('span.accessible-contrast-color-location').text,
      salary: element.css('span.salaryText').text
    }
    jobs << job
  end

  json = JSON.pretty_generate(jobs)

  File.open('jobData.json', 'w') { |file| file.write(json)}

end

scraper
