require 'nokogiri'
require 'httparty'
require 'pry'

# languages = ['ruby', 'rails', 'javaScript', 'react', 'postgresql']

def scraper
    url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"
  page_content = HTTParty.get(url)
  parsed_content = Nokogiri::HTML(page_content)
  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')
  # specific_job_listings = parsed_content.css('div.sjcl')

  job_company = job_listings.css('span.company')
  job_role = job_listings.css('h2.title').text
  job_location = job_listings.css('span.accessible-contrast-color-location')
  job_salary = job_listings.css('span.salaryText')
  # job_link = job_role.css('a')[0].attributes('href').values

    jobs = Array.new
    job_link_index_array = Array.new

    job_listings.each do |element|
      job = {
        company: element.css('span.company').text,
        position: element.css('h2.title').text,
        location: element.css('span.accessible-contrast-color-location').text,
        salary: element.css('span.salaryText').text,
        age: element.css('span.date').text,
        description: element.css('div.summary').text,
        # Can't include links because element is job listings! Must use job_role outside of this hash and then push it in.
      }
        jobs << job
    end

      job_role.each do |x|
        job_link_hash = {
          link: x.css('a')[0].attributes('href').values
        }
          
      end

    # job_link_index_num = 0
    # while job_link_index_num < 15 do
    #   job_link_index_num += 1
    #   job_link_index_array << job_link_index_num
    # end
    #
    # while job_link_index_num < 15 do
    #   job_link_index_num += 1
    #   poo = job_role.css('a')["#{job_link_index_num}"].attributes('href').values
    #   binding.pry
    # end

      # job_link_index_array.each do |x|
      #
      # end

  json = JSON.pretty_generate(jobs)

  File.open('jobData.json', 'w') { |file| file.write(json)}

end

scraper
