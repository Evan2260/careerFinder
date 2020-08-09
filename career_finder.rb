require 'nokogiri'
require 'httparty'
require 'pry'

def scraper
    url = "https://www.indeed.com/jobs?q=Software%20Engineer&l=Boston%2C%20MA&rbl=Boston%2C%20MA&jlid=e167aeb8a259bcac&sort=date&vjk=04ef7a50c33007f7"
  page_content = HTTParty.get(url)
  parsed_content = Nokogiri::HTML(page_content)
  job_listings = parsed_content.css('div.jobsearch-SerpJobCard')
  job_company = job_listings.css('span.company')
  job_role = job_listings.css('h2.title')
  job_location = job_listings.css('span.accessible-contrast-color-location')
  job_salary = job_listings.css('span.salaryText')
  # job_link = job_role.css('a')[0].attributes['href'].value

  job_urls = [
    job_role.css('a')[0].attributes['href'].value,
    job_role.css('a')[1].attributes['href'].value,
    job_role.css('a')[2].attributes['href'].value,
    job_role.css('a')[3].attributes['href'].value,
    job_role.css('a')[4].attributes['href'].value,
    job_role.css('a')[5].attributes['href'].value,
    job_role.css('a')[6].attributes['href'].value,
    job_role.css('a')[7].attributes['href'].value,
    job_role.css('a')[8].attributes['href'].value,
    job_role.css('a')[9].attributes['href'].value,
    job_role.css('a')[10].attributes['href'].value,
    job_role.css('a')[11].attributes['href'].value,
    job_role.css('a')[12].attributes['href'].value,
    job_role.css('a')[13].attributes['href'].value,
    job_role.css('a')[14].attributes['href'].value
  ]
  #Could refactor by using .map and .value at the end of the array???

    #Following gives us names with links but no url
    # job_a = job_role.css('a[href]').attributes['href'].value

    job_b = parsed_content.css('tr')

binding.pry

  # job_a = job_role.css('a')[0..15]

  # job_href = job_a.css('href')

  # job_link = job_role.css('a._blank')[0..15][attribute=value]

    jobs = Array.new
    job_link_index_array = Array.new

    job = {}

    job_listings.each do |element|
      job = {
        company: element.css('span.company').text,
        position: element.css('h2.title').text,
        location: element.css('span.accessible-contrast-color-location').text,
        salary: element.css('span.salaryText').text,
        age: element.css('span.date').text,
        description: element.css('div.summary').text,
        url: "indeed.com"
      }
        jobs << job
    end


    # a = [1, 2, 3, 4]
    # # invoking block for each element
    # puts "collect a : #{a.collect {|x| x + 1 }}\n\n"
    # puts "collect a : #{a.collect {|x| x - 5*7 }}\n\n"

    # binding.pry

    # job_link_index_num = 0
    #
    # while job_link_index_num < 15 do
    #   job_link_index_num += 1
    #   job_link_index_array << job_link_index_num
    # end


  # Code 2 : Example for collect() method

  # Ruby code for collect() method

  # declaring array
  # b = ["cat", "rat", "geeks"]
  #
  # # invoking block for each element
  # puts "collect b : #{b.collect {|x| x + "!" }}\n\n"
  #
  # puts "collect b : #{b.collect {|x| x + "_at" }}\n\n"

      # job_role.each do |x, y|
      #   job_link_hash = {
      #     link: x.css('a')[y].attributes['href'].values
      #   }
      # end


    # job_link_index_array.each do |x|
    #     job[:link] = job_role.css('a')[0].attributes['href'].values
    # end

    # while job_link_index_num < 15 do
    #   job_link_index_num += 1
    #   poo = job_role.css('a')["#{job_link_index_num}"].attributes('href').values
    #   binding.pry
    # end

  json = JSON.pretty_generate(jobs)

  File.open('jobData.json', 'w') { |file| file.write(json)}

end

scraper
