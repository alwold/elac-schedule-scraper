require 'elac-class-info'

class ElacScheduleScraper
  def get_class_info(term, subject, section)
    doc = ElacScheduleScraper.do_course_search(term, subject)
    doc.xpath("//table[@id='gvCourseAvailable']//tr[td]").each do |course|
      if course.xpath("td")[1].text == section
        ci = ElacClassInfo.new
        ci.name = course.xpath("td")[2].text
        ci.schedule = course.xpath("td")[12].text << ' ' << course.xpath("td")[3].text
        return ci
      end
    end
    return nil
  end

  def get_class_status(term, subject, section)
  end

  def self.do_course_search(term, subject)
    uri = URI('http://academicportal.elac.edu/searchengine.aspx')
    doc = Nokogiri::HTML(Net::HTTP.get(uri))

    viewstate = doc.xpath("//input[@name='__VIEWSTATE']")[0]['value']
    eventvalidation = doc.xpath("//input[@name='__EVENTVALIDATION']")[0]['value']

    res = Net::HTTP.post_form(uri, '__VIEWSTATE' => viewstate, '__EVENTVALIDATION' => eventvalidation, 'ddlSemester' => term, 'ddlCourseName' => '', 'txtSearch' => subject, 'ddlDeptName' => '', 'ddOnlineClasses' => '', 'ddDays' => '', 'cmdSearchClasses.x' => '81', 'cmdSearchClasses.y' => '13')
    doc = Nokogiri::HTML(res.body)
  end
end
