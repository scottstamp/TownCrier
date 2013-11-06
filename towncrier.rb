require 'cinch'
require 'set'
require 'sequel'
require_relative 'cache.rb'

bot = Cinch::Bot.new do
	config = YAML.load('config.yml')
	tags = Set.new
	re = /(.+?) - (.+) \[(\d+)\] \[([^\]]+)\] - (MP3|FLAC|Ogg|AAC|AC3|DTS|Ogg Vorbis) \/ ((?:24bit)?(?: ?Lossless)?(?:[\d|~|\.xVq|\s]*(?:AAC|APX|APS|Mixed|Auto|VBR)?(?: LC)?)?(?: ?(?:\(VBR\)|\(?ABR\)?|[K|k][b|p]{1,2}s)?)?)(?: \/ (Log))?(?: \/ ([-0-9\.]+)\%)?(?: \/ (Cue))?(?: \/ (CD|DVD|Vinyl|Soundboard|SACD|Cassette|DAT|WEB|Blu-ray))(?: \/ (Scene))?(?: \/ Freeleech!)? - https:\/\/what\.cd\/torrents\.php\?id=(\d+) \/ https:\/\/what\.cd\/torrents\.php\?action=download&id=(\d+) - ?(.*)/

	configure do |c|
		c.server = 'irc.what-network.net'
		c.nick = 'towncrier'
		c.name = 'town crier 0.1'
	end

	on :connect do
		User('Drone').send "ENTER #what.cd-announce #{config['irc_user']} #{config['irc_key']}"
	end

	on :message, re do |m|
		msg = re.match(m.message)
		puts msg.inspect
		puts '##################'
		puts "Artist - #{msg[1]}"
		puts "Album Title - #{msg[2]}"
		puts "Format - #{msg[5]}"
		puts "Quality - #{msg[6]}"
		puts "Tags - #{msg[14]}"
		puts ""

		tags.merge(msg[14].split(',').collect(&:strip))
		puts tags.inspect

		Cache.cache_torrent(
			{
				:artist => msg[1],
				:album => msg[2],
				:year => msg[3],
				:type => msg[4],
				:format => msg[5],
				:quality => msg[6],
				:log => msg[7],
				:logper => msg[8],
				:cue => msg[9],
				:source => msg[10],
				:group_id => msg[12],
				:download_id => msg[13],
				:tags => msg[14]
			}
		)
	end
end

bot.loggers.level = :fatal
bot.loggers.first.level = :fatal
bot.start
