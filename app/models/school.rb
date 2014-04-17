class School < ActiveRecord::Base
	has_many :properties
	has_many :property_schools
	has_many :listings
  #has_many :bookmarks

	def center
		Geocoder::Calculations.geographic_center(self.properties)
	end

	def noncampus_properties
		Property.joins(:property_schools).where(property_schools:{school_id: self.id})
	end

	########################
	#### FILTER OPTIONS ####
	def self.analytics_objects_options
		[["All Listings", "Listing"], ["Rental Listings", "rentals"], ["Sublet Listings", "sublets"], ["Marketplace Listings", "MarketplaceItem"], ["Roommate Listings", "RoommateListing"], ["Landlords", "Landlords"]]
	end

  def self.analytics_objects
    self.analytics_objects_options.map{|object| object[1]}
  end

  def self.analytics_functions
    ['Active','New','Deactivated','Banned']
  end

  def self.analytics_timescales
	  ['Daily','Weekly','Monthly','Yearly','All Time']
  end

  #########################
  #### FILTER_LISTINGS ####
  def filter_listings(object, function, timescale)
		if timescale == 'All Time'
			query = self.listings
			query = query.where(property_type: object).where.not(listable_type:'Property') if object != "Listing"
			query = query.where(active: true)  if function == 'Active'
			query = query.where(active: false) if function == 'Deactivated'
			query = query.where(banned: true)  if function == 'Banned'
			return query.count,  "All Time" 
		end

  	listings = []
  	x_axis = []
  	i = 0
  	while self.advance_date(i,timescale) <= Date.today
      query = self.listings.where.not(listable_type: 'Property')
      query = query.where(property_type: object) unless object == "Listing"
      query = query.where("listings.created_at <= '#{self.advance_date(i+1,timescale)}'")
      query = query.where("listings.created_at >= '#{self.advance_date(i,timescale)}'") if function == 'New'
      query = query.where(active: true)  if function == 'Active'
  		query = query.where(active: false) if function == 'Deactivated'
  		query = query.where(banned: true)  if function == 'Banned'
  		listings << query.count
  		x_axis << self.x_axis_label(i,timescale)
  		i += 1
  	end
  	return listings, x_axis
  end

  ########################
  #### FILTER HELPERS ####
  def advance_date(i,timescale)
  	time_hash_advance = {years: i} if timescale == 'Yearly'
  	time_hash_advance = {months: i} if timescale == 'Monthly'
  	time_hash_advance = {weeks: i} if timescale == 'Weekly'
  	time_hash_advance = {days: i} if timescale == 'Daily'
  	return self.created_at.advance(time_hash_advance).midnight
  end

  def x_axis_label(i,timescale)
  	return self.advance_date(i,timescale).year if timescale == 'Yearly'
  	return Date::MONTHNAMES[self.advance_date(i,timescale).month] if timescale == 'Monthly'
  	return self.advance_date(i,timescale).strftime("%m/%d/%Y")
  end

end