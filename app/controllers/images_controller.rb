##
# ImagesController implements methods for uploading, maniuplating, and destroying images.
# 
class ImagesController < ApplicationController
	before_filter :authenticate_user!

	def create
		key_uuid_filename = params[:url].split('%2F')
		uuid = key_uuid_filename[1]
		encoded_filename = key_uuid_filename[2]
		if property = @current_account.properties.where(uuid: uuid).first
			imageable = property
		elsif item = @current_account.marketplace_items.where(uuid: uuid).first
			imageable = item
		elsif @current_account.roommate_listing.uuid == uuid
			imageable = @current_account.roommate_listing
		elsif @current_account.uuid == uuid
			imageable = @current_account
		end
		@image = imageable.images.create(encoded_filename: encoded_filename)
		imageable.update(first_image_url: @image.url('thumb')) unless imageable.first_image_url
	end

	def destroy
		image = Image.find(params[:id].to_i)
		imageable = image.imageable
		image.destroy
		newimage = imageable.images.first ||
		newimage_url = newimage ? newimage.url(:thumb) : nil
		imageable.update(first_image_url: newimage_url)
	end

private

	def image_params
		params.require(:image).permit(:encoded_filename)
	end

end