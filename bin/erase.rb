$: << 'lib'

require 'date'
require 'csv'

require 'rubygems'
require "bundler/setup"

require 'twitter'
require 'lib_trollop'

@opts = Trollop::options do
  raise Trollop::HelpNeeded if ARGV.empty? # show help screen
  
  opt :"start-date", "Tweets before this date will not be deleted", :short => 's', :type => Date, :required => true
  opt :"end-date", "Tweets after this date will not be deleted", :short => 'e', :type => Date, :required => true
  
  version "shame-eraser 0.1 (c) 2012 Benjamin Jackson"
  banner <<-EOS
Shame Eraser is a small Ruby script for erasing your shame on Twitter (i.e., your oldest tweets).

Usage:
       erase.rb [options] <foldername>
where [options] are:
EOS

end

raise Trollop::HelpNeeded if ARGV.empty? # show help screen

TWEET_ARCHIVE_DIR = ARGV[0]

@twitter = Twitter::Client.new

def delete_tweets_in_file filepath
  lines = CSV.read(filepath)
  id_index = lines.first.index("tweet_id")
  date_index = lines.first.index("timestamp")

  lines[1..-1].each do |row|
    puts row.inspect
    date = Date.parse(row[date_index])
    if (@opts[:"start-date"]...@opts[:"end-date"]).include?(date)
      id = row[id_index]
      @twitter.status_destroy(id)
    end
  end
end

Dir.glob(File.join(TWEET_ARCHIVE_DIR, "data", "csv", "*")).each do |filepath|
  date_string = File.basename(filepath).sub(".csv", "").sub("_", "-")
  date = Date.parse("#{date_string}-01")
  if (@opts[:"start-date"]...@opts[:"end-date"]).include?(date)
    delete_tweets_in_file(filepath)
  end
end