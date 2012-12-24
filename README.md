# shame-eraser


A small Ruby script for erasing your shame on Twitter (i.e., your oldest tweets).  

### Author 

[Benjamin Jackson](http://twitter.com/benjaminjackson)

### Instructions:

#### Set Up A Twitter App

First, you'll have to set up a Twitter app on the developer portal and generate an OAuth key.

1. Visit the [Twitter Developer Apps](https://dev.twitter.com/apps) page and [create a new app](https://dev.twitter.com/apps/new), filling out only the required fields.
2. Go to the "Settings" tab for your app, scroll down, and change "Application Type" to "Read and Write", then click "Update this Twitter application's settings".
3. Go to the "Details" tab, scroll down, and click "Create my access token" (or "Recreate my access token" if you already created one). When you refresh, you should see "Access Level: Read and Write" after your access token and secret.

#### Download Shame Eraser from Github

Download [this archive](https://github.com/benjaminjackson/shame-eraser/archive/master.zip) and unzip it.

#### Delete Your Old Tweets

Download your tweet archive and unzip it. Next, you'll have to run some things on the command line. Open the Terminal (just type "Terminal" into Spotlight), copy and paste this into the tab that opens up, and hit Enter:

    cd ~/Downloads/shame-eraser-master && sudo gem install bundler && bundle install && open lib
    
*Note: if you changed your default downloads folder, you'll need to change "~/Downloads" to the path to your downloads folder. You can get this by dragging the folder onto Terminal.*

Now copy your consumer key, consumer secret, access token, and access token secret into lib/config.rb and then copy and paste this line *without* pressing Enter:

    bundle exec ruby bin/erase.rb 
    
Drag your tweets folder onto Terminal and it should auto-complete the path to the folder. *Now* hit Enter. The script will prompt you for a start and end date, and confirm that you **really** want to do this.