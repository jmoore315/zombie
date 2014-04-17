##
# AccountsController implements methods for manipulating account permissions and structure.
# Note that an Account is not a User and so this controller should not implement email- or
# password-reset methods.
# 
class AccountsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :grant_permissions
	
	def listings

		if @current_account.role == 'school_admin'
			redirect_to root_url
		else
		# properties
			@properties = Property.includes(:property_schools).where(account_id: @current_account.id, deleted: nil).order('active DESC')
			@locations = @properties.map {|p| [p.latitude,p.longitude]}
			
			# marketplace items
			@items = MarketplaceItem.where(account_id: @current_account.id, deleted: nil).order('active DESC')
			
			# roommate listings
			roommate_listing = @current_account.roommate_listing
			@roommate_listing = roommate_listing if roommate_listing && !roommate_listing.deleted?
		end
	end

	def bookmarks
		unless @current_account.role == 'student'
			redirect_to root_url
		else 
			bookmarks = Bookmark.where(account_id: @current_account.id)
			@rental_bookmarks 	= []
			@sublet_bookmarks 	= []
			@item_bookmarks 	= []
			@roommate_bookmarks = []
			bookmarks.each do |bookmark|
				type = bookmark.bookmarkable_type
				@rental_bookmarks 	<< bookmark if type == 'UnitClass' && bookmark.bookmarkable.property.property_type == 'rentals'
				@sublet_bookmarks 	<< bookmark if type == 'UnitClass' && bookmark.bookmarkable.property.property_type == 'sublets'
				@item_bookmarks 	<< bookmark if type == 'MarketplaceItem'
				@roommate_bookmarks << bookmark if type == 'RoommateListing'
			end
		end
	end

	def settings
		if @permissions == 'student' || @permissions == 'landlord'
			redirect_to settings_user_url
		else
			redirect_to settings_profile_url
		end
	end

	def settings_profile
		if @permissions == 'student'
			redirect_to settings_url
		else
			@name = @current_account.name
			@telephone = @current_account.telephone
			@email = @current_account.email
			@logo = @current_account.image
			@co_or_school = (@permissions == 'school_admin' ? 'School' : 'Company')
		end
	end

	def settings_company
		if @permissions == 'landlord_admin'
			# To be filled in when we add the ability to add landlord non-admins
		else
			redirect_to settings_url
		end
	end

	def settings_user
		@first_name = current_user.first_name
		@last_name = current_user.last_name
		@email = current_user.email
		@telephone = @current_account.telephone if @permissions == 'student'
	end

	def settings_notifications
		@notify_listings = current_user.notify_listings
		@notify_newsletter = current_user.notify_newsletter
		@notify_major_announcements = current_user.notify_major_announcements
	end

	def settings_billings
		if @permissions == 'landlord' || @permissions == 'landlord_admin'
			# To be filled in when we add the ability to bill landlords
		else
			redirect_to settings_url
		end
	end

	def settings_payments
		if @permissions == 'landlord' || @permissions == 'landlord_admin'
			# To be filled in when we add the ability to bill landlords
		else
			redirect_to settings_url
		end
	end

	def update_settings_profile
		if @permissions == 'student'
			redirect_to settings_url
		else
			@current_account.update(account_params)
			redirect_to settings_profile_url
		end
	end

	def update_settings_company
		if @permissions == 'landlord_admin'
			# To be filled in when we add the ability to add landlord non-admins
		else
			redirect_to settings_url
		end
	end

	def update_settings_user
		@current_account.update(user_account_params) if @permissions == 'student'
		current_user.update(user_params)
		if current_user.unconfirmed_email.present?
			flash[:notice] = "Check your email to confirm your new address. The old address will remain until confirmation is complete."
		end
		redirect_to settings_user_url
	end

	def update_settings_notifications
		current_user.update(user_params)
		redirect_to settings_notifications_url
	end

	def update_settings_billing
		if @permissions == 'landlord_admin' || @permissions == 'landlord'
			# To be filled in when we add the ability to bill landlords
		else
			redirect_to settings_url
		end
	end

	def update_email
		if current_user.email != user_params[:email]
			current_user.update(user_params)
			@email_updated = true
		end
	end

	def deactivate
		if @permissions == 'student' || @permissions == 'landlord_admin'
			if deactivate_params["email"] == current_user.email && deactivate_params["phrase"] == 'Please deactivate my account' && current_user.valid_password?(deactivate_params["password"])
				@current_account.deactivate
				sign_out(current_account)
				redirect_to root_url, alert: "Your account has been deleted"
			else
				redirect_to settings_user_url, alert: "One or more deactivation fields was incorrect."
			end
		end
	end

private

	def user_params
		params.require(:user).permit(:email, :first_name, :last_name, :notify_listings, :notify_newsletter, :notify_major_announcements)
	end

	def user_account_params
		params.require(:user).permit(account: :telephone)
	end

	def account_params
		params.require(:account).permit(:name, :telephone, :email)
	end

	def deactivate_params
		params.permit("phrase","email","password")
	end

	def grant_permissions
		if @current_account.role == 'student'
			@permissions = 'student'
		elsif @current_account.role == 'landlord' && current_user.admin == true
			@permissions = 'landlord_admin'
		elsif @current_account.role == 'landlord'
			@permissions = 'landlord'
		elsif @current_account.role == 'school_admin'
			@permissions = 'school_admin'
		end
	end

end