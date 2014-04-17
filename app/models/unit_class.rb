class UnitClass < ActiveRecord::Base
  belongs_to :property  
  has_many :messages, as: :messageable
  has_many :listings, as: :listable
  has_many :bookmarks, as: :bookmarkable

  before_create :set_defaults
  before_destroy { |unit|
    unit.listings.destroy_all
  }

  #########################################
  #### CREATION AND LISTING MANAGEMENT ####

  def set_defaults
    self.bedrooms = 0
    self.bathrooms = 10
    self.roommates = 0
    self.price = 0
  end

  def activate(school_ids, property_type)
    self.update(active: true)
    school_ids.each { |id| self.find_or_create_listing(id, property_type) }
  end

  def deactivate
    self.update(active: false)
    self.deactivate_listings
  end

  def ban
    self.update(active: false, deleted: true)
    self.ban_listings
  end

  def delete
    self.update(active: false, deleted: true)
    self.delete_listings
  end

  #######################
  #### PRETTY PRINTS ####
  def pretty_rent
    price.present? ? "$#{price}" : "$????"
  end

  def pretty_rent_per_bedroom
    return "$#{price}" if price.present? && self.bedrooms == 0
    return "$#{(price/(self.bedrooms/10)).round}" if price.present?
    return "Contact landlord for price"
  end

  def pretty_bedrooms
    self.bedrooms == 0 ? 'Studio' : "#{self.bedrooms/10}"
  end

  def pretty_bathrooms
    bthrms = self.bathrooms*0.1
    return "#{bthrms.floor}" if bthrms.floor == bthrms      
    return "#{bthrms}"
  end

  def pretty_lease
    lf = self.lease_from && self.lease_from.strftime('%-m/%-d/%-y')  || '????'
    lt = self.lease_until && self.lease_until.strftime('%-m/%-d/%-y') || '????'
    return "#{lf} - #{lt}"
  end

  ###########################
  #### LISTING UTILITIES ####

  def deactivate_listings
    self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
  end

  def ban_listings
    self.listings.where(active: true).update_all(active: false, banned: true, closed_at: DateTime.now)
  end

  def delete_listings
    self.listings.where(active: true).update_all(active: false, deleted: true, closed_at: DateTime.now)
  end

  ############################
  #### UTILITY FUNCTIONS #####

  def find_or_create_listing(school_id, property_type)
    self.listings.where(active: true, property_type: property_type, school_id: school_id).first_or_create
  end

  def close_faraway_listings(school_ids)
    for listing in self.listings.where(active: true) do
      listing.update(active: false, closed_at: DateTime.now) unless school_ids.include? listing.school_id
    end
  end

  def self.bedroom_options
    [
      ['Studio',0],
    	['1',10],
    	['2',20],
    	['3',30],
    	['4',40],
    	['5',50],
    	['6',60],
    	['7',70],
    	['8',80],
    	['9',90],
    	['10+',100]
    ]
  end

  def self.bedroom_options_rentals
    [
      ['Studio',0],
      ['1 bedroom',10],
      ['2 bedrooms',20],
      ['3 bedrooms',30],
      ['4 bedrooms',40],
      ['5 bedrooms',50],
      ['6 bedrooms',60],
      ['7 bedrooms',70],
      ['8 bedrooms',80],
      ['9 bedrooms',90],
      ['10+ bedrooms',100]
    ]
  end

  def self.bathroom_options
    [
      ['1',10],
      ['1.5',15],
      ['2',20],
      ['2.5',25],
      ['3',30],
      ['3.5',35],
      ['4',40],
      ['4.5',45],
      ['5',50],
      ['5.5',55],
      ['6',60],
      ['6.5',65],
      ['7',75],
      ['7.5',75],
      ['8',80],
      ['8.5',85],
      ['9',90],
      ['9.5',95],
      ['10 or more',100]
    ]
  end

  def self.bathroom_options_rentals
    [
      ['1   bathroom',10],
      ['1.5 bathrooms',15],
      ['2   bathrooms',20],
      ['2.5 bathrooms',25],
      ['3   bathrooms',30],
      ['3.5 bathrooms',35],
      ['4   bathrooms',40],
      ['4.5 bathrooms',45],
      ['5   bathrooms',50],
      ['5.5 bathrooms',55],
      ['6   bathrooms',60],
      ['6.5 bathrooms',65],
      ['7   bathrooms',75],
      ['7.5 bathrooms',75],
      ['8   bathrooms',80],
      ['8.5 bathrooms',85],
      ['9   bathrooms',90],
      ['9.5 bathrooms',95],
      ['10  or more bathrooms',100]
    ]
  end

  def self.roommate_options
    [
      ["None",0],
      ["One",1],
      ["Two",2],
      ["Three",3],
      ["Four",4],
      ["Five or more",5]
    ]
  end

  def self.orders_select
    [
      ['Sort by Distance to Campus', 'distance'],
      ['Sort by Lowest Price'      , 'unit_classes.price ASC'],
      ['Sort by Lease Start Date'  , 'unit_classes.lease_from ASC'],
      ['Sort by Newest'            , 'unit_classes.created_at DESC']
    ]
  end

  def self.orders
    self.orders_select.map{ |i| i[1] }
  end

  ## The FILTER method allows a student to search and sort units by campus and attributes.
  #  It has one required argument, school_id, which tells the method what school to search at.
  #  It has a number of optional constraints:
  #  - :order must be in UnitClass.orders
  #  - :property_type must be 'rentals' or 'sublets'
  #  - :beds must be one of 0,10,20,30,40,50,60,70,80,90, or 100
  #  - :baths must be one of 10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95, or 100.
  #  - :roommates must be one of 0,1,2,3,4, or 5
  #  - :size must be a nonnegative integer
  #  - :price_min must be a nonnegative integer <= :price_max
  #  - :price_max must be a nonnegative integer >= :price_min
  #  - :lease_from must be a datetime that comes before :lease_until
  #  - :lease_until must be a datetime that comes after :lease_from
  def self.filter(school_id, options = {})
    options[:order]  ||= 'distance'
    raise ArgumentError, "options[:order] must be in #{self.orders}" unless self.orders.include? options[:order]
    raise ArgumentError, "school_id must be positive Fixnum" unless school_id.class == Fixnum

    max_distance = 15
    max_distance = 3 if options[:property_type] == 'sublets'
    max_distance = 3 if options[:include_graduate] == "false"
    # property_ids = Property.joins(:property_schools).where(property_schools: {school_id: school_id}).where("property_schools.distance <= #{max_distance}").uniq.map(&:id)
    query = UnitClass.joins(property: :property_schools).where(active: true).where(property_schools: {school_id: school_id}).where("property_schools.distance <= #{max_distance}")
    query = query.where(property_type: options[:property_type])               if options[:property_type]
    query = query.where(bedrooms: options[:beds])                             if options[:beds]
    query = query.where(bathrooms: options[:baths])                           if options[:baths]
    query = query.where(roommates: options[:roommates])                       if options[:roommates]
    query = query.where(graduate_only: options[:include_graduate].to_boolean) if options[:include_graduate] == "false"
    query = query.where("price >= #{options[:price_min].to_i}")  if options[:price_min]
    query = query.where("price <= #{options[:price_max].to_i}")  if options[:price_max]
    query = query.where("size >= #{options[:size].to_i - 150} AND size <= #{options[:size].to_i + 150}") if options[:size]
    query = query.where("lease_from >= '#{options[:lease_from].to_datetime - 1.month}' AND lease_from <= '#{options[:lease_from].to_datetime + 1.month}'") if options[:lease_from]
    query = query.where("lease_until >= '#{options[:lease_until].to_datetime - 1.month}' AND lease_until <= '#{options[:lease_until].to_datetime + 1.month}'") if options[:lease_until]
    query = query.where(property_schools: {school_id: school_id})
    query.order('property_schools.distance').includes(property: :property_schools)
  end

end