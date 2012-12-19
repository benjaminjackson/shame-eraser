require 'rubygems'
require "bundler/setup"

require 'twitter'
require File.join(File.dirname(__FILE__), "lib", "lib_trollop")

opts = Trollop::options do
  opt :"start-date", "Tweets before this date will not be deleted", :short => 's', :type => Date, :required => true
  opt :"end-date", "Tweets after this date will not be deleted", :short => 'e', :type => Date :required => true
end

