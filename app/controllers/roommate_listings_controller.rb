##
# RoommateListingsController allows you to add a profile of yourself for the "roommate search" function.
#
class RoommateListingsController < ApplicationController
	before_filter {|controller| controller.send(:authenticate_role, 'student')}
	before_filter :find_listing, except: :new

	def new
		unless @current_account.roommate_listing.present?
			@roommate_listing = @current_account.create_roommate_listing
			render 'show'
		else
			redirect_to roommate_listing_url
		end
	end

	def show
	end

	def update
		@roommate_listing.update(roommate_listing_params)
	end

	def delete
		@roommate_listing.delete
		redirect_to listings_url
	end

	def activate
		@roommate_listing.activate
		redirect_to listings_url
	end

	def deactivate
		@roommate_listing.deactivate
		redirect_to listings_url
	end

private

	def find_listing
		@roommate_listing = @current_account.roommate_listing
	end

	def roommate_listing_params
		params.require(:roommate_listing).permit(:gender, :grad_year, :ideal_rent, :occupancy_date,
			:fb_link, :telephone, :pref_gender, :pref_smoking, :pref_pets, :pref_cleanliness,
			:pref_social, :pref_age, :age, :cleanliness, :social, :title, :description
		)
	end
	
end