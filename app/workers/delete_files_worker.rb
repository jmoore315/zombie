class DeleteFilesWorker
	include Sidekiq::Worker

	def perform(uuid, filename)
		image_key      = "uploads/#{uuid}/#{filename}"
		thumb_key    = "uploads/#{uuid}/thumb_#{filename}"
		carousel_key = "uploads/#{uuid}/carousel_#{filename}"
		DeleteFilesWorker.deletefile(image_key)
		DeleteFilesWorker.deletefile(thumb_key)
		DeleteFilesWorker.deletefile(carousel_key)
	end

	def self.deletefile(key)
		file = self.downloadfile(key)
		file.destroy if file
	end

	def self.downloadfile(key)
		self.bucket.files.get(key)
	end

	def self.bucket
		connection = Fog::Storage.new({
  		provider: 'AWS',
  		aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  		aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  	}).directories.get("uhoused-pictures")
	end

end