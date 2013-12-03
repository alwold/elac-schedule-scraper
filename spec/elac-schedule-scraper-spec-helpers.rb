require 'net/http'
require 'nokogiri'

module ElacScheduleScraperSpecHelpers
  def get_class(status)
    uri = URI('http://academicportal.elac.edu/searchengine.aspx')
    doc = Nokogiri::HTML(Net::HTTP.get(uri))

    viewstate = doc.xpath("//input[@name='__VIEWSTATE']")[0]['value']
    eventvalidation = doc.xpath("//input[@name='__EVENTVALIDATION']")[0]['value']

    res = Net::HTTP.post_form(uri, '__VIEWSTATE' => viewstate, '__EVENTVALIDATION' => eventvalidation, 'ddlSemester' => '20140', 'ddlCourseName' => '', 'txtSearch' => '', 'ddlDeptName' => '', 'ddOnlineClasses' => '', 'ddDays' => '', 'cmdSearchClasses.x' => '81', 'cmdSearchClasses.y' => '13')
    doc = Nokogiri::HTML(res.body)
    doc.xpath("//table[@id='gvCourseAvailable']//tr[td]").each do |course|
      seats = course.xpath("td")[7].text.to_i
      ci = ClassInfo.new
      ci.subject = course.xpath("td")[0].text.split(' ')[0]
      ci.section = course.xpath("td")[1].text
      if status == :open && seats > 0
        return ci
      elsif seats == 0
        return ci
      end
    end
  end
end

class ClassInfo
  attr_accessor :subject
  attr_accessor :section
end