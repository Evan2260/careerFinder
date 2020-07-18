require 'nokogiri'
require 'httparty'
require 'pry'

languages = ['ruby', 'rails', 'javaScript', 'react', 'postgresql']

def scraper
  url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"
  page_content = HTTParty.get(url)
  parsed_content = Nokogiri::HTML(page_content)
  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')
  # specific_job_listings = parsed_content.css('div.sjcl')

  job_company = job_listings.css('span.company')
  job_role = job_listings.css('h2.title')
  job_location = job_listings.css('span.accessible-contrast-color-location')
  job_salary = job_listings.css('span.salaryText')
  job_link = job_role.css('a')[0].attributes['href'].value

  jobs = Array.new
  array_of_links = Array.new

  job_listings.each do |element|
    job = {
      company: element.css('span.company').text,
      position: element.css('h2.title').text,
      location: element.css('span.accessible-contrast-color-location').text,
      salary: element.css('span.salaryText').text,
      age: element.css('span.date').text,
      description: element.css('div.summary').text,
      link: "https://www.indeed.com#{job_link}"
    }
      jobs << job
  end

  hash_job_link = job_link.map do |element|
    puts element
  end

  binding.pry

  json = JSON.pretty_generate(jobs)

  File.open('jobData.json', 'w') { |file| file.write(json)}

end
scraper
