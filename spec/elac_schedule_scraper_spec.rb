require 'elac-schedule-scraper'
require 'elac-schedule-scraper-spec-helpers'

RSpec.configure do |config|
  config.include ElacScheduleScraperSpecHelpers
end

describe ElacScheduleScraper do
  it "gets current term" do
    expect(get_current_term.length).to eq(5)
  end
end
