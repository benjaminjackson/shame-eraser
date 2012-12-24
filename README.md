# shame-eraser

Now that Twitter has made it easy to download our entire tweet archives, the Internet is now faced with the scary reality that the dumbest things we've ever said are only a few clicks away. Our early tweets were sent from a time of innocence, joy, and freedom from the realization that one day other people (and we ourselves) might pass judgement on them. 

But the time of reckoning has come. And if you're unable to bear the weight of your shame, this is your way out. Perhaps you had a particularly dark period after a break-up. Maybe your first six months on Twitter were just bad haikus. If you're the type of person who rips up your old shitty poems, this script is for you.

**Important:** this should be obvious, but to be sure **there is no undo** for this script. If you haven't seen *Eternal Sunshine of the Spotless Mind*, you might want to watch it first. Weigh your options carefully before erasing your past. (You will, of course, still have your local archive after deleting the public tweets.)

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
    
Drag your tweets folder onto Terminal and it should auto-complete the path to the folder. *Now* hit Enter, and follow the instructions.

Good luck, and enjoy your new shame-free life on Twitter.