class RoommateListing < ActiveRecord::Base
	belongs_to :account
	has_many :images, as: :imageable
  has_many :messages, as: :messageable
  has_many :listings, as: :listable
  has_many :bookmarks, as: :bookmarkable


	validates :title, length: { maximum: 100 }
	validates :description, length: { maximum: 500 }
	#validates :account_id, :uniqueness => true
	before_destroy { |roommate_listing|
		roommate_listing.images.destroy_all
		roommate_listing.listings.destroy_all
	}


  #########################################
  #### CREATION AND LISTING MANAGEMENT ####

	def set_defaults
		self.uuid = SecureRandom::uuid()
	end

  def activate
    self.update(active: true)
    self.listings.where(active: true, school_id: School.where(code: self.account.code).first.id).first_or_create
  end

  def deactivate
    self.update(active: false)
    self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
  end

  def ban
    self.update(active: false)
    self.listings.where(active: true).update_all(active: false, banned: true, closed_at: DateTime.now)
  end

  def delete
  	self.deactivate
  	self.update(deleted: true)
  end

  def change_school
    self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
    self.listings.where(active: true, school_id: School.where(code: self.account.code).first.id).first_or_create
  end

  #######################
  #### PRETTY PRINTS ####
	def pretty_print_attribute (attribute)
		self[attribute] || "N/A"
	end

  ############################
  #### UTILITY FUNCTIONS #####

	def self.genders
		["Male","Female","Prefer Not To Answer"]
	end

	def self.pref_genders
		["Any","Male","Female"]
	end

	def self.pref_smoking
		["Any", "No","Yes"]
	end

	def self.cleanliness
		["Very Clean","Somewhat Clean","Messy"]
	end

	def self.pref_cleanliness
		["Any", "very clean","Somewhat Clean","Messy"]
	end

	def self.social
		["Very Social","Somewhat Social","Not Very Social"]
	end

	def self.pref_social
		["Any", "Very Social","Somewhat Social","Not Very Social"]
	end

	def self.pref_pets
		["Any","No Pets"]
	end

	def self.pref_smoking
		["Any","No Smoking"]
	end

	def self.orders
		['roommate_listings.created_at DESC']
	end

	# The FILTER method lets you search and sort RoommateListings by campus and attributes.
	# It has one required argument, school_code, which tells the method what campus to search at.
	# It has a number of optional constraints:
	# - :order must be in the list of orders
	def self.filter(school_code, options = {})
		options[:order] ||= 'roommate_listings.created_at DESC'
		raise ArgumentError, "options[:order] must be in #{self.orders}" unless self.orders.include? options[:order]
    raise ArgumentError, "school_code must be in the list of school codes" unless School.pluck(:code).include? school_code
    RoommateListing.joins(:account).where(active: true, accounts:{code: school_code}).order(options[:order])
	end

end
