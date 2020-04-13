require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)

    html = Nokogiri::HTML(open(index_url))
    students = []

    html.css("div.student-card").each do |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      student_info = {:name => name,
                  :location => location,
                  :profile_url => profile_url}
      students << student_info
    end
    students
  end

  def self.scrape_profile_page(profile_url)

    html = Nokogiri::HTML(open(profile_url))
    student = {}

    storage = html.css(".vitals-container .social-icon-container a")
    storage.each do |link|
      if link.attribute('href').value.include?("twitter")
        student[:twitter] = link.attribute('href').value
      elsif link.attribute('href').value.include?("linkedin")
        student[:linkedin] = link.attribute('href').value
      elsif link.attribute('href').value.include?("github")
        student[:github] = link.attribute('href').value
      else 
        student[:blog] = link.attribute('href').value
      end
    end
    student[:profile_quote] = html.css("div.vitals-text-container .profile-quote").text
    student[:bio] = html.css(".bio-block.details-block .bio-content.content-holder .description-holder p").text
    student
  end

end
