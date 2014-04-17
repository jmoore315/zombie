##
# ListingsController contains all methods for viewing listings of rentals, sublets,
# marketplaces, and roommates at a particular school.
#
class ListingsController < ApplicationController
	before_filter(only: [:view_roommate_listings, :view_roommate_listing]) {|controller| controller.send(:authenticate_role, ['student','school_admin'])}
	before_filter :set_school, except: [:school_list, :choose_school]
	before_filter :authenticate_school_admin, only: [:view_roommate_listings, :view_roommate_listing]

	def school_list
		render json: School.where(active: true).order(:name).pluck(:name)
	end

	def choose_school
		@school = School.where(name: params[:school]).first
		if @school
			redirect_to school_home_url(school_code: @school.code)
		else
			redirect_to school_home_url(school_code: params[:school])
		end
	end

	def view_school
		school_center = @school.center
		@latitude = school_center[0]
		@longitude = school_center[1]
		@new_rentals = UnitClass.filter(
			@school.id,
			property_type:'rentals',
			include_graduate: "true",
			order: 'unit_classes.created_at DESC').page(1).per(3).to_a
		@new_sublets = UnitClass.filter(
			@school.id,
			property_type:'sublets',
			order: 'unit_classes.created_at DESC').page(1).per(3).to_a
		@new_marketplace = MarketplaceItem.filter(
			@school.code,
			order: 'marketplace_items.created_at DESC').page(1).per(3).to_a
		@locations = Property.near_school(@school.id).to_a
	end

	def view_properties
		@page             = params[:page].present? ? params[:page].to_i : 1
		@price_min        = params[:price_min].to_i
		@price_max        = params[:price_max].present? ? params[:price_max].to_i : 10000
		@sort_by	        = params[:sort_by] || 'distance'
		@property_type    = params[:property_type]
		@include_graduate = params[:include_graduate]
		@graduate_only    = params[:graduate_only]
		@bedrooms         = params[:bedrooms].present?  ? params[:bedrooms].to_i : nil
		@bathrooms        = params[:bathrooms].present? ? params[:bathrooms].to_i : nil
		@size             = params[:size].present?      ? params[:size].to_i : nil
		@roommates        = params[:roommates].present? ? params[:roommates].to_i : nil
		@lease_picker     = params[:lease_picker] if params[:lease_picker].present?
		lease_from  = @lease_picker ? Date.strptime(@lease_picker[0..10],"%m/%d/%Y")  : nil
		lease_until = @lease_picker ? Date.strptime(@lease_picker[13..22],"%m/%d/%Y") : nil

		rentals = UnitClass.filter(@school.id, {
			property_type: @property_type,
			include_graduate: @include_graduate,
			beds: @bedrooms,
			baths: @bathrooms,
			size: @size,
			roommates: @roommates,
			price_min: @price_min,
			price_max: @price_max,
			lease_from: lease_from,
			lease_until: lease_until,
			order: @sort_by
		})
		@rentals = rentals.page(@page).per(10)
		@count   = rentals.count
		@pages   = (@count/10.0).ceil
		#properties = rentals.map {|rental| rental.property_id}.uniq.sort
		@locations = []
		for rental_unit in @rentals do 
			@locations << rental_unit.property
		end
		@locations.uniq!
		#@locations = Property.where(id: properties)
		#@locations should just be the array of Properties from @rentals
		school_center = @school.center
		@latitude = school_center[0]
		@longitude = school_center[1]
	end

	def view_property
		@rental = UnitClass.find(params[:id])
		@property = @rental.property
		@images = @property.images.order(:id)
		@message = Message.new
		@manage_or_post = @property.property_type == 'sublets' ? 'Post' : 'Manag'
		@similar_listings = UnitClass.filter(@school.id, property_type: @property.property_type, beds: @rental.bedrooms).to_a.shuffle.first(10)
		@similar_listings.select! { |x| x.property_id != @rental.property_id }
		@property_type = @property.property_type
		if @property.latitude			
			@latitude  = @property.latitude
			@longitude = @property.longitude
		else
			school_center = @school.center
			@latitude = school_center[0]
			@longitude = school_center[1]
		end
		
		@bookmark = @current_account.bookmarks.where(bookmarkable_id: @rental.id, bookmarkable_type: 'UnitClass').first if @current_account
	end
	
	def view_marketplace
		@property_type = 'marketplace'
		@page          = params[:page].present? ? params[:page].to_i : 1
		@price_min     = params[:price_min].to_i
		@price_max     = params[:price_max].present? ? params[:price_max].to_i : 10000
		@category      = params[:category].present? ? params[:category] : nil
		@subcategory   = params[:subcategory].present? ? params[:subcategory] : nil
		@condition     = params[:condition].present? ? params[:condition] : nil
		@sort_by       = params[:sort_by] || 'marketplace_items.created_at DESC'
		items = MarketplaceItem.filter(@school.code, {
			order: @sort_by,
			category: @category,
			subcategory: @subcategory,
			price_min: @price_min,
			price_max: @price_max,
			condition: @condition
		})
		@items = items.page(@page).per(10)
		@count = items.count
		@pages = (@count/10.0).ceil
	end

	def view_item
		@item    = MarketplaceItem.where(id: params[:id].to_i, active: true).first
		@poster_first_name = @item.account.users.first.first_name
		@property_type = 'marketplace'
		@similar_listings = MarketplaceItem.filter(@school.code, subcategory: @item.subcategory, exclude: @item.id, include_images: false).to_a.shuffle.first(10)
		@users_other_items = MarketplaceItem.where(active: true, account_id: @item.account_id)
		@users_other_items = @users_other_items.where.not(id: @item.id)
		redirect_to root_url unless @item
		@images  = @item.images.order(:id).to_a
		@message = Message.new
		@bookmark = @current_account.bookmarks.where(bookmarkable_id: @item.id, bookmarkable_type: 'MarketplaceItem').first if @current_account
	end

	def view_roommate_listings
		@page = params[:page].present? ? params[:page].to_i : 1
		@property_type = 'roommate_listings'
		roommate_listings = RoommateListing.filter(@school.code)
		@roommate_listings = roommate_listings.page(@page).per(10)
		@count = roommate_listings.count
		@pages = (@count/10.0).ceil
	end

	def view_roommate_listing
		@roommate_listing = RoommateListing.where(id: params[:id].to_i).first
		redirect_to root_url unless @roommate_listing
		@images = @roommate_listing.images.order(:id)
		@property_type = "roommate_listings"
		@bookmark = @current_account.bookmarks.where(bookmarkable_id: @roommate_listing.id, bookmarkable_type: 'RoommateListing').first if @current_account

	end

private

	def set_school
		@school = School.where(code: params[:school_code]).first
	end

	def authenticate_school_admin
		render file:'public/404' if @current_account.role == 'school_admin' && @current_account.code != @school.code
	end

end