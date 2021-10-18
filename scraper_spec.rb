#!/home/david/.rvm/rubies/ruby-2.7.2/bin/ruby

require "./scraper"

describe "#run" do
	it "should run" do
		scraper = Scraper.new()
		scraper.run()		
	end
end



