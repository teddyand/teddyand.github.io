#!/home/david/.rvm/rubies/ruby-2.7.2/bin/ruby

require 'rubygems'
require 'mechanize'
require 'vcr'
#VCR.configure do |c| 
#	c.cassette_library_dir = 'cached'
#	c.hook_into :webmock
#end

class Scraper
	attr_accessor :root
	attr_accessor :agent
	attr_accessor :pages

	def initialize
		@root = "http://blog.sina.com.cn/s/articlelist_5896726763_0_1.html"#"http://blog.sina.com.cn/s/articlelist_1311967407_0_1.html"  #"https://www.jianshu.com/u/01c8e5010ac0"
		#@body = 
		@agent = Mechanize.new
		@pages =[]
		#@links 
	end

	def scrape
		#begin
		#	VCR.use_cassette("sina") do
				url = "#{@root}"#{i}"
				page = @agent.get(url) 				
				#puts page.links
				pages << page
				
		#	end		 	
		rescue Exception => e
			STDERR.puts "Unable to scrape this file"
		#end	
	end



	def run
		#100.times do |i|			
			scrape()
			character =0
			#puts @pages.links
			@pages.each do |page| 
				rows =(page /"a[title]")  #爬取博文目录								
				articles = rows.length
				rows.each do  |row| 
					 puts row.text 
					 puts row.values[2] 					 
					 page1 =@agent.get(row.values[2])
					 puts page1 
					 body =(page1 /"div[id=sina_keyword_ad_area2]")		#爬取博文正文
					 puts body.text.strip	#显示正文
					 puts body.text.length	#显示正文字数
					 character = character + body.text.length
				end 			#显示博文目录最近标题												
				#dates =(page /"p[class=atc_info]")#爬取博文发表日期
				puts "From 2016 within today You have writen #{articles} articles #{character/2}  characters"
			end
			
			
	end
end