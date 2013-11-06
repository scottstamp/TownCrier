DB = Sequel.connect('do:mysql://root:crier@localhost/crier')
require_relative('lib/create_tables')
require_relative('lib/models')

class Cache
	def self.cache_torrent(set = :set)
		Torrent.create(
			:artist 	=> set[:artist],
			:album		=> set[:album],
			:year		=> set[:year],
			:type		=> set[:type],
			:format		=> set[:format],
			:quality	=> set[:quality],
			:log		=> set[:log],
			:logper		=> set[:logper],
			:cue		=> set[:cue],
			:source		=> set[:source],
			:group_id	=> set[:group_id],
			:download_id	=> set[:download_id],
			:tags		=> set[:tags]
		)
	end
end
