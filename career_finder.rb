require 'nokogiri'
require 'httparty'
require 'pry'

def scraper
  url = "https://github.com/trending?since=weekly"

  page_content = HTTParty.get(url)

  parsed_content = Nokogiri::HTML(page_content)

  # When in pry we can now put parsed_content.css('article.Box-row')

  # Have also been saving as a variable in the terminal like so: projects_data = parsed_content.css('article.Box-row')

  #Will give us all information we need in text:
  # projects_data = parsed_content.css('article.Box-row').text

 #All trending data
  projects_data = parsed_content.css('article.Box-row')
  binding.pry

  # Will give us all company names in text:
  # projects_data.css('span.text-normal').text
  project_companies = projects_data.css('span.text-normal').text

  #Project Description:
  project_desc = projects_data.css('p.col-9.text-gray.my-1.pr-4').text

  #Project languages:
  project_languages = projects_data.css('span.d-inline-block.ml-0.mr-3').text.strip

  #Main Contributors
  project_contributors = projects_data.css('avatar.mb-1').text

  # binding.pry

  puts projects_data
  puts project_companies
  puts project_desc
  puts project_languages
  puts project_contributors
  #======================================================
  #By typing the following into the terminal, we can now get the name of the company/devteam's githubs, AND the name of the projects

  # projects = projects_data.css('a').text
  #======================================================

  # projects_array = []
  #
  # projects_array << projects


  #projects.first will give us the first of 25 of the github projects. I saved the first one under a variable like so: project_1 = projects.first

  #By typing the following into the terminal, we can now get the name of the company/devteam's github, AND the name of the project: project_1.css('a').text

  #By typing the following into the terminal, we can now get the name of the company/devteam's github: project_1.css('span.text-normal').text

  #
end

scraper
