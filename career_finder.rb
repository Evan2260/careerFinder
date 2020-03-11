require 'nokogiri'
require 'httparty'
require 'pry'

def scraper
  url = "https://www.indeed.com/jobs?q=Software+Engineer&l=Boston%2C+MA&rbl=Boston%2C+MA&jlid=e167aeb8a259bcac&fromage=last&sort=date"

  page_content = HTTParty.get(url)

  parsed_content = Nokogiri::HTML(page_content)

  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')

  job_title = job_listings.css('div.title').text

    if job_title.include? "Full Stack"
      puts job_title
    end



end
scraper


# May have to put all job titles in an array and then use method arrays
