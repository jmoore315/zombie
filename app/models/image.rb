class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true
  before_create :set_defaults
  after_commit :process_versions, on: :create
  before_destroy :delete_files

  def set_defaults
    self.imageable_uuid = self.imageable.uuid
    self.filename = URI.unescape(self.encoded_filename.gsub("+"," "))
  end

  def process_versions
    GenerateVersionsWorker.perform_async(self.imageable_uuid, self.filename)
  end

  def delete_files
    DeleteFilesWorker.perform_async(self.imageable_uuid, self.filename)
  end

  def url(image_version = nil)
    image_version = "#{image_version}_" unless image_version == nil
    "https://s3.amazonaws.com/uhoused-pictures/uploads/#{self.imageable_uuid}/#{image_version}#{self.encoded_filename}"
  end

end