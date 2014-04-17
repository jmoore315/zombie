class Account < ActiveRecord::Base
	has_many :users
	has_many :properties
	has_many :unit_classes, through: :properties
	has_many :marketplace_items
	has_many :messages
	has_many :listings, as: :listable
	has_one :roommate_listing
	has_one :image, as: :imageable
	has_many :bookmarks

	before_create :set_defaults
	before_destroy { |account|
		account.users.destroy_all
		account.properties.destroy_all
		account.marketplace_items.destroy_all
		account.messages.destroy_all
		account.listings.destroy_all
		account.roommate_listing.destroy if account.roommate_listing
		account.image.destroy if account.image
		account.bookmarks.destroy_all
	}

  #########################################
  #### CREATION AND ACCOUNT MANAGEMENT ####

	def set_defaults
		self.email = self.users.first.email if ['student','school_admin','admin'].include? self.role
		self.uuid = SecureRandom::uuid()
		self.active = true
	end

	def deactivate
		self.deactivate_posting_listings
		self.deactivate_listings
		self.update(active: false, deactivated_at: DateTime.now)
	end

	def ban
		self.ban_posting_listings
		self.ban_listings
		self.update(active: false, deactivated_at: DateTime.now)
	end

	def close_school_listing_if_no_properties
		school_ids = self.listings.where(active: true).pluck(:school_id)
		school_ids.each {|id| close_listing_at_school(id) unless has_active_properties_at_school(id) }
	end

  ############################
  #### LISTINGS UTILITIES ####
	def has_active_properties_at_school(school_id)
		property_ids = self.properties.where(active: true).pluck(:id)
		Listing.where(listable_id: property_ids, listable_type: 'Property', active: true, school_id: school_id).present?
	end

	def close_listing_at_school(school_id)
		self.listings.where(active: true, school_id: school_id).update_all(active: false, deleted: true, closed_at: DateTime.now)
	end

	def find_or_create_listing(school_id)
    Listing.where(active: true, school_id: school_id, listable_type:'Account', listable_id: self.id).first_or_create
	end

  def deactivate_posting_listings
		self.properties.each {|p| p.deactivate }
		self.users.each {|u| u.deactivate }
		self.marketplace_items.each {|i| i.deactivate }
		self.roommate_listing.deactivate if self.roommate_listing
  end

  def deactivate_listings
		self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
  end

  def ban_posting_listings
		self.properties.each {|p| p.ban }
		self.users.each {|u| u.ban }
		self.marketplace_items.each {|i| i.ban}
		self.roommate_listing.ban if self.roommate_listing
  end

  def ban_listings
  	self.listings.where(active: true).update_all(active: false, banned: true, closed_at: DateTime.now)
  end

	#########################
	#### OTHER UTILITIES ####
	def school
		School.where(code: self.code, active: true).first
	end

	def can_create_property_type(property_type)
		return true if self.role == 'student'  && property_type == 'sublets'
		return true if self.role == 'landlord' && property_type == 'rentals'
		return true if self.role == 'admin'
		return false
	end

end