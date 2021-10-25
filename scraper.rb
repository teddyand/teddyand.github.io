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
		@root = "http://blog.sina.com.cn/s/articlelist_1311967407_0_"
		#"http://blog.sina.com.cn/s/articlelist_5896726763_0_1.html"#"http://blog.sina.com.cn/s/articlelist_1311967407_0_1.html"  #"https://www.jianshu.com/u/01c8e5010ac0"
		#@body = 
		@agent = Mechanize.new
		@pages =[]
		#@links 
	end

	def scrape
		(1..8).each do |i|
		#begin
		#	VCR.use_cassette("sina") do
				url = "#{@root}#{i}.html"
				@agent.get(url) do |page|
					pages << page				
				end		 	
		rescue Exception => e
			STDERR.puts "Unable to scrape this file"
		end	
	end



	def run		
			scrape()
			character =0
			articles =0
			#puts @pages.links
			@pages.each do |page| 
				rows =(page /"a[title=\"\"]")  #爬取博文目录								
				articles += rows.length
				rows.each do  |row| 
					 puts row.text 
					 #puts row.values[2] 					 
					 page1 =@agent.get(row.values[2])
					 #puts page1 
					 body =(page1 /"div[id=sina_keyword_ad_area2]")		#爬取博文正文
					 #puts body.text.strip	#显示正文
					 #puts body.text.length	#显示正文字数
					 character = character + body.text.length
				end 			#显示博文目录最近标题				
			days =(page / "p[class=atc_info]")											
			day =days[days.length-1].text.strip
			present =days[0].text.strip
			author = (page / "title").text.gsub(/[博文_新浪博客]/,'')
			dates =(page /"p[class=atc_info]")#爬取博文发表日期
			puts "From #{day} to the #{present} #{author} have writen #{articles} articles #{character/2}  characters about #{character/2/articles} characters per article"	
			end	
			
	end
end

#2.7.2 :640 > (1..8).each do |i|
#   url = "http://blog.sina.com.cn/s/articlelist_1311967407_0_#{i}.html"
#   @agent.get(url) do |page|
#     items = page / "a[title=\"\"]"
#     puts items.length
#     items.each do |item| puts item.text end
#     count += items.length 
#   end
#   puts count
# end

####### Oct 24th 
#(1..8).each do |i|
#   url = "http://blog.sina.com.cn/s/articlelist_1311967407_0_#{i}.html"
#   @agent.get(url) do |page| items =page / "a[title=\"\"]"
#    finals = items.grep(/大师/)
#    finals.each do |final|
#      puts final.text
#      puts final.values[2]
#   end
#  end
#end


#2.7.2 :722 > (1..8).each do |i|
#2.7.2 :723 >   url = "http://blog.sina.com.cn/s/articlelist_1311967407_0_#{i}.html"
#2.7.2 :724 >   @agent.get(url) do |page| items =page / "a[title=\"\"]"
#2.7.2 :725 >    finals = items.grep(/大师之后再无大师/)
#2.7.2 :726 >    finals.each do |final|
#2.7.2 :727 >      puts final.text
#2.7.2 :728 >      page1 = @agent.get(final.values[2]) do |page1|
#2.7.2 :729 >        body =(page1 /"div[id=sina_keyword_ad_area2]")#爬取博文正文
#2.7.2 :730 >        puts body.text.strip
#2.7.2 :731 >      end
#2.7.2 :732 >    end
#2.7.2 :733 >   end
#2.7.2 :734 > end


## author =[]
# characters =0
# articles =0
#2.7.2 :189 > (1..8).each do |i|
#2.7.2 :190 >   url = "http://blog.sina.com.cn/s/articlelist_1311967407_0_#{i}.html"
#2.7.2 :191 >   @agent.get(url) do |page|
#2.7.2 :192 >     author = (page /"title").text.gsub(/[博文_新浪博客]/,'')
#2.7.2 :193 >     puts author
#2.7.2 :194 >     items = page / "a[title=\"\"]"
#2.7.2 :195 >     items.each do |item|
#2.7.2 :196 >       puts item.text
#2.7.2 :197 >       page1 = @agent.get(item.values[2]) do |page1|
#2.7.2 :198 >         body =(page1 /"div[id=sina_keyword_ad_area2]")#爬取博文正
#2.7.2 :199 >         characters +=body.text.length
#2.7.2 :200 >       end
#2.7.2 :201 >     end
#2.7.2 :202 >   end
#2.7.2 :203 > end
#puts "author #{author} have writen #{characters/2} about #{characters/2/400} per article"

#author 作家岳南 have writen 596999 about 1492 per article
