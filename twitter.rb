require "jumpstart_auth"

class MicroBlogger
	attr_reader :client


	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end

	def tweet
		print "> "
		message = gets.chomp

		if message.length > 140
			puts "This message exceeds twitter's 140 character limit!!"
		else
			@client.update(message)	
		end
	end

	def dm
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name} 
		print "Username of twitter user: "
		target = gets.chomp
		if screen_names.include?(target) == true
			print "What  do you want to say: "
			tweet = gets.chomp
			@client.create_direct_message(target, tweet)
		else
			puts "sorry you can only direct message your followers"
		end
	end
	
	def spam_followers
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name}
		print "what do you want to spam?: "
		message = gets.chomp
		screen_names.each do |name|
			@client.update("@#{name} #{message}")
		end

	end
	

	def everyones_last_tweet
		friends = @client.friends
	
		friends.each do |friend|
			name = @client.user(friend).screen_name
			words = @client.user(friend).status.text
			time_stamp = @client.user(friend).status.created_at
			time_stamp.strftime("%A, %b %d")
			puts "#{name} at #{time_stamp} says..."
			puts words
			puts ""
			
		
		end

	end




	def run
		command = ""
		puts "Welcome to Gerard's Twitter Client!"
		while command != "q"
			print "enter a command: "
			command = gets.chomp
			case command
				when "q" then puts "Goodbye"
				when "t" then tweet
				when "dm" then dm
				when "spam" then spam_followers
				when "elt" then everyones_last_tweet
				else
					puts "Sorry, I dont know how to #{command}"
			end
		end
	end
end

bot = MicroBlogger.new
bot.run
