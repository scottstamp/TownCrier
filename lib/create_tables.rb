DB.create_table? :torrents do
	primary_key :id
	String :artist
	String :album
	String :year
	String :type
	String :format
	String :quality
	String :log
	String :logper
	String :cue
	String :source
	String :group_id
	String :download_id
end
