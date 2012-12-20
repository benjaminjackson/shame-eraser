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
  puts "\nHow many of your early tweets would you like to delete? Enter a number, or 'date' to specify a date range."
  @opts[:number] = gets.chomp
  while @opts[:number].to_i <= 0 && @opts[:number] != "date"
    puts "Please specify a number greater than 0, or 'date'."
    @opts[:number] = gets.chomp.to_i
  end
  @opts[:number] = @opts[:number].to_i
end

if @opts[:number] == "date"
  [:"start-date", :"end-date"].each do |key|
    if @opts[key].nil?
      while !@opts[key].is_a?(Date)
        begin
          puts "\nWhat's the #{key == :"start-date" ? "start" : "end"} date? Example: 'a year ago', 'January 2009'"
          @opts[key] = Chronic::parse(gets.chomp).to_date
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
      # Twitter.status_destroy(id)
      @total_deleted += 1
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
  puts "\nThis action will PERMANENTLY delete your first #{@opts[:number]} tweets for @#{Twitter.user.username}. Are you absolutely certain beyond a shadow of a doubt that you want to do this? There is no undo. (Y/n)"
end
confirmation = gets.chomp

if confirmation == "Y"
  puts "Deleting tweets..."
  Dir.glob(File.join(TWEET_ARCHIVE_DIR, "data", "csv", "*")).each do |filepath|
    delete_tweets_in_file(filepath)
  end
end