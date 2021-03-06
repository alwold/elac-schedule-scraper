require 'elac-schedule-scraper-spec-helpers'

RSpec.configure do |config|
  config.include ElacScheduleScraperSpecHelpers
end

describe ElacScheduleScraper do
  it 'gets current term' do
    expect(get_current_term.length).to eq(5)
  end
  it 'can get class info' do
    scraper = ElacScheduleScraper.new
    ci = scraper.get_class_info('20141', 'ACADPR', '8701')
    expect(ci.name).to eq('LANGUAGE ARTS: WRITING SENTENCES')
    expect(ci.schedule).to eq('MW 9:10AM-10:40AM')
  end
  it 'returns nil for nonexistent class' do
    scraper = ElacScheduleScraper.new
    expect(scraper.get_class_info(get_current_term, 'foo', 'bar')).to be_nil
  end
  it 'gets status of an open class' do
    scraper = ElacScheduleScraper.new
    term = get_current_term
    open = get_class(:open)
    expect(scraper.get_class_status(term, open.subject, open.section)).to eq(:open)
  end
  it 'gets nil for nonexistent class' do
    scraper = ElacScheduleScraper.new
    term = get_current_term
    expect(scraper.get_class_status(term, 'foo', 'bar')).to be_nil
  end
end
