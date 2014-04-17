require 'RMagick'
class GenerateVersionsWorker
	include Sidekiq::Worker
	def perform(uuid, filename)
		image_key      = "uploads/#{uuid}/#{filename}"
		thumb_key    = "uploads/#{uuid}/thumb_#{filename}"
		carousel_key = "uploads/#{uuid}/carousel_#{filename}"
		fullsize = GenerateVersionsWorker.rmagick_image(image_key)
		GenerateVersionsWorker.generate_new_size(fullsize, thumb_key, 100, 100)
		GenerateVersionsWorker.generate_new_size(fullsize, carousel_key, 620, 450)
	end

	def self.generate_new_size(rmagick_image, key, width, height)
		self.bucket.files.create(
			key: key,
			body: rmagick_image.resize_to_fill(width, height).to_blob,
			acl: 'public-read',
			encryption: 'AES256',
			content_type: self.content_type(key)
		)
	end

	def self.content_type(key)
    return 'image/jpeg' if key.downcase.end_with?('.jpg') || key.downcase.end_with?('.jpeg')
    return 'image/png'  if key.downcase.end_with?('.png')
    return 'binary/octet-stream'
	end

	def self.rmagick_image(key)
		return Magick::Image.from_blob(self.downloadfile(key).body).first
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