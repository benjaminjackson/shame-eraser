require 'date'
require 'csv'

require 'rubygems'
require "bundler/setup"

require 'twitter'
require 'chronic'

$: << 'lib'

require 'lib_trollop'
require 'config'

p = Trollop::Parser.new do
  
  version "shame-eraser 0.1 (c) 2012 Benjamin Jackson"
  banner <<-EOS

shame-eraser 0.1 (c) 2012 Benjamin Jackson

Shame Eraser is a small Ruby script for erasing your shame on Twitter (i.e., your oldest tweets). 

Usage:
       erase.rb [options] <foldername>

You can run it without options and just follow the prompts, or specify them on the command line as follows:
EOS

opt :"start-date", "Tweets before this date will not be deleted", :short => 's', :type => Date
opt :"end-date", "Tweets after this date will not be deleted", :short => 'e', :type => Date
opt :number, "Number of tweets to be deleted, starting from the first", :short => 'n', :type => Integer
  
end

@opts = Trollop::with_standard_exception_handling p do
  raise Trollop::HelpNeeded if ARGV.empty? # show help screen
  p.parse ARGV
end

TWEET_ARCHIVE_DIR = ARGV.shift

if @opts[:number].nil?
  puts "\nHow many of your early tweets would you like to delete?" 
  puts "Enter a number, or 'date' to specify a date range." 
  puts "For example, '50' will delete your first 50 tweets."
  @opts[:number] = gets.chomp.strip
  while @opts[:number].to_i <= 0 && !@opts[:number].to_s.include?("date")
    puts "Please specify a number greater than 0, or 'date'."
    @opts[:number] = gets.chomp.strip
  end
  @opts[:number] = "date" if @opts[:number].to_s.include?("date")
  @opts[:number] = @opts[:number].to_i unless @opts[:number] == "date"
end

if @opts[:number] == "date"
  [:"start-date", :"end-date"].each do |key|
    if @opts[key].nil?
      while !@opts[key].is_a?(Date)
        begin
          puts "\nWhat's the #{key == :"start-date" ? "start" : "end"} date? Example: 'a year ago', 'January 2009'. Tweets #{key == :"start-date" ? "before" : "after"} this date will not be deleted."
          @opts[key] = Date::parse(Chronic::parse(gets.chomp.strip).strftime("%Y-%m-%d"))
          puts "Great! That looks like #{@opts[key].to_s}."
        rescue
          puts "Error parsing date. Please try again."
        end
      end
    end
  end
end

@total_deleted = 0

def delete_tweets_in_file filepath
  lines = CSV.read(filepath)
  id_index = lines.first.index("tweet_id")
  date_index = lines.first.index("timestamp")

  # reverse so it's earliest tweets first
  lines[1..-1].reverse.each_with_index do |row, index|
    date = Date.parse(row[date_index])
    if (@opts[:number] != "date" && @total_deleted < @opts[:number]) || 
       (@opts[:number] == "date" && (@opts[:"start-date"]...@opts[:"end-date"]).include?(date))
      id = row[id_index]
      puts "Deleting tweet with ID #{id}"
      begin
        Twitter.status_destroy(id)
        @total_deleted += 1
      rescue Twitter::Error::NotFound
        puts "Tweet not found. Perhaps you already deleted this one?"
      end
    end
    if @opts[:number] != "date" && @total_deleted == @opts[:number]
      puts "Finished deleting #{@opts[:number]} tweets"
      exit 
    end
  end
end

if @opts[:number] == "date"
puts "\nThis action will PERMANENTLY delete your tweets for @#{Twitter.user.username} between #{@opts[:"start-date"]} and #{@opts[:"end-date"]}. Are you absolutely certain beyond a shadow of a doubt that you want to do this? There is no undo. (Y/n)"
else
  tweets_phrase = @opts[:number] > 1 ? "your first #{@opts[:number]} tweets" : "your first tweet"
  puts "\nThis action will PERMANENTLY delete #{tweets_phrase} for @#{Twitter.user.username}. Are you absolutely certain beyond a shadow of a doubt that you want to do this? There is no undo. (Y/n)"
end
confirmation = gets.chomp.strip

if confirmation == "y"
  puts "Is that a 'yes'? Just making sure."
  confirmation = gets.chomp.strip
end

if confirmation == "Y" || confirmation == 'yes'
  puts "Deleting tweets..."
  delete_tweets_in_file(File.join(TWEET_ARCHIVE_DIR, "tweets.csv"))
else
  puts "Canceling"
end
