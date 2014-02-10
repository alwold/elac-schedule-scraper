require 'net/http'
require 'nokogiri'
require 'elac-schedule-scraper'

module ElacScheduleScraperSpecHelpers
  def get_class(status, term = get_current_term)
    doc = ElacScheduleScraper.do_course_search(term, '')
    doc.xpath("//table[@id='gvCourseAvailable']//tr[td]").each do |course|
      seats = course.xpath("td")[7].text.to_i
      ci = ClassInfo.new
      ci.subject = course.xpath("td")[0].text.split(' ')[0]
      ci.section = course.xpath("td")[1].text
      if status == :open && seats > 0
        return ci
      elsif status == :closed && seats == 0
        return ci
      end
    end
  end

  def get_current_term
    uri = URI('http://academicportal.elac.edu/searchengine.aspx')
    doc = Nokogiri::HTML(Net::HTTP.get(uri))
    doc.xpath("//select[@name='ddlSemester']/option")[1]['value']
  end
end

class ClassInfo
  attr_accessor :subject
  attr_accessor :section
end