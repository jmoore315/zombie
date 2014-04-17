class MarketplaceItem < ActiveRecord::Base
  belongs_to :account
  has_many :images, as: :imageable
  has_many :messages, as: :messageable
  has_many :listings, as: :listable
  has_many :bookmarks, as: :bookmarkable

  validate  :category_is_valid, on: :update, if: "self.category.present?"

	before_create :set_defaults
  before_validation :set_category, on: :update
  before_destroy { |item|
    item.images.destroy_all
    item.listings.destroy_all
  }

  ###################
  #### CALLBACKS ####
  def set_defaults
    self.uuid = SecureRandom::uuid()
    self.condition = "new"
    self.category = "Furniture"
    self.subcategory = "Chairs"
  end

  def set_category
    self.category = self.subcategory.category
  end

  #####################
  #### VALIDATIONS ####
  def category_is_valid
    errors[:base] << "The category is invalid." unless self.category.subcategories.present?
    errors[:base] << "The subcategory is invalid" unless self.subcategory.category.present?
  end

  ############################
  #### LISTING MANAGEMENT ####
  def activate
    self.update(active: true)
    self.find_or_create_listing
  end

  def deactivate
    self.update(active: false)
    self.deactivate_listing
  end

  def ban
    self.update(active: false)
    self.ban_listing
  end

  def delete
    self.update(deleted: true)
    self.delete_listing
  end

  def change_school
    self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
    self.listings.where(active: true, school_id: School.where(code: self.account.code).first.id).first_or_create
  end

  ######################
  #### PRETTY PRINT ####
  def pretty_name
    return self.name if self.name
    return "Unnamed Item"
  end

  def pretty_price
    self.price.present? ? "$#{price}" : "$????"
  end

  ###########################
  #### LISTING UTILITIES ####
  def find_or_create_listing
    self.listings.where(active: true, school_id: School.where(code: self.account.code).first.id).first_or_create
  end

  def deactivate_listing
    self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
  end

  def ban_listing
    self.listings.where(active: true).update_all(active: false, banned: true, closed_at: DateTime.now)
  end

  def delete_listing
    self.listings.where(active: true).update_all(active: false, deleted: true, closed_at: DateTime.now)
  end


  ############################
  #### UTILITY FUNCTIONS #####
  def self.conditions_select
    [
      ['New','New'],
      ['Like New','Like New'],
      ['Very Good','Very Good'],
      ['Good','Good'],
      ['Acceptable','Acceptable']
    ]
  end

  def self.conditions
    self.conditions_select.map{ |i| i[0] }
  end

  def self.subcategories_select
    [
      ["Furniture"   , ["Chairs","Tables","Desks","TV Stands","Storage"]],
      ["Bedroom"     , ["Beds and Box Springs","Mattresses"]],
      ["Bathroom"    , ["Bathroom Accessories"]],
      ["Laundry"     , ["Laundry Baskets and Hampers"]],
      ["Kitchen"     , ["Cookware","Food Containers","Refrigerators"]],
      ["Lighting"    , ["Floor Lamps","Desk Lamps"]],
      ["Rugs"        , ["Area Rugs"]],
      ["Electronics" , ["Televisions","Phones","Computers","Cameras","Other"]],
      ["Media"       , ["Textbooks","Books","Movies and TV","Music","Video Games","Board Games"]],
      ["Outdoor"     , ["Bicycles","Sports Equipment","Grills","Patio Furniture"]]
    ]
  end

  def self.categories_select
    self.subcategories_select.map{|i| i[0]}
  end

  def self.orders_select
    [
      ['Sort by Lowest Price', 'marketplace_items.price ASC'],
      ['Sort by Highest Price', 'marketplace_items.price DESC'],
      ['Sort by Newest', 'marketplace_items.created_at DESC']
    ]
  end

  def self.orders
    self.orders_select.map{|i| i[1]}
  end

	# The FILTER method lets you search and sort MarketplaceItems by campus and attributes.
  #  It has one required argument, school_code, which tells the method what campus to search at.
  #  It has a number of optional constraints:
  #  - :order must be in the list of orders
  #  - :category must be a string matching a category from the database
  #  - :subcategory must be a string matching a subcategory from the database
  #  - :price_min must be a nonnegative integer <= :price_max
  #  - :price_max must be a nonnegative integer >= :price_min
  #  - :condition must be in the list of conditions
  #  - :exclude must be an integer referring to the id of a MarketplaceItem to exclude from the filter.
	def self.filter(school_code, options = {})
		options[:order] ||= 'marketplace_items.created_at DESC'
		raise ArgumentError, "options[:order] must be in #{self.orders}" unless self.orders.include? options[:order]
    raise ArgumentError, "school_code must be in the list of school codes" unless School.pluck(:code).include? school_code

    account_ids = Account.where(code: school_code, active: true).uniq.map(&:id)
    query = MarketplaceItem.where(active: true, account_id: account_ids)
    query = query.where(subcategory: options[:subcategory]) if options[:subcategory]
    query = query.where(category: options[:category])       if options[:category]
    query = query.where(condition: options[:condition])     if options[:condition]
    query = query.where("marketplace_items.price >= #{options[:price_min].to_i}") if options[:price_min]
    query = query.where("marketplace_items.price <= #{options[:price_max].to_i}") if options[:price_max]
    query = query.where.not(id: options[:exclude].to_i) if options[:exclude]
    query = query.order(options[:order])
    query = query.includes(:images) unless options[:include_images] == false
    return query
	end
end