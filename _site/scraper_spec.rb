#!/home/david/.rvm/rubies/ruby-2.7.2/bin/ruby

require "./scraper"

describe "#run" do
	before :each do
		@scraper =Scraper.new
	end

	describe "#process_titles" do
		it "should correct title with double quotes" do
			str =' someting " with a double quote'
			expect(@scraper.process_title(str)).to_not match(/"/)
		end

		it "should strip whitespace from titles" do
			str ='\n\n someting betweent newlins \n\n'
			expect(@scraper.process_title(str)).to_not match(/^\n\n/)
		end

		it "should not crash if the title is nil" do
			expect{ @scraper.process_title( nil) }.to_not raise_error()			
		end
	end

	describe "#get_filename" do
		it "should take 'Cuba - the good and bad' on Oct 12th,2021"+ "and get a proper filename" do
			input = 'Cuba - the good and bad'
			date = "Oct 12th,2021"
			output ="2021-10-12-cuba-the-good-and-bad.md"
			expect( @scraper.get_filename(input,date) ).to eq(output)
		end

		it "should 'Mexico/Belize/Guatemala' and get a proper filename" do
			input ="Mexico/Belize/Guatemala"
			date ="2021-08-22"
			output = "2021-08-22-mexico-belize-guatemala.md"
			expect( @scraper.get_filename(input,date) ) .to eq(output)
		end
	end

end



