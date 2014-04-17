class Property < ActiveRecord::Base
  belongs_to :account
  belongs_to :school
  has_many :unit_classes
  has_many :images, as: :imageable
  has_many :listings, as: :listable
  has_many :property_schools
  has_many :schools, through: :property_schools

  validates         :account_id, presence: true, unless: "school_id.present?"
  validates         :school_id, presence: true, unless: "account_id.present?"
  after_validation  :geocode, if: Proc.new {|property| property.address_changed }
  after_validation  :rename_and_redistance, if: Proc.new {|p| p.address_changed && p.property_type != 'campus' && p.property_type.present? }
  geocoded_by       :full_address, latitude: :latitude, longitude: :longitude
  before_create     :set_defaults
  before_destroy { |property|
    property.unit_classes.destroy_all
    property.images.destroy_all
    property.listings.destroy_all
  }

  #########################################
  #### CREATION AND LISTING MANAGEMENT ####

  def set_defaults
    self.state ||= 'AL'
    self.uuid = SecureRandom::uuid()
    self.graduate_only = false
    account = self.account
    self.property_type = 'sublets' if account && account.role == 'student'
    self.property_type = 'rentals' if account && account.role == 'landlord'
    self.property_type = 'campus'  if account == nil
  end

  def activate
    school_ids = self.property_schools.pluck(:school_id)
    self.activate_units
    self.update(active: true)
    for school_id in school_ids
      self.find_or_create_listing(school_id)
      self.account.find_or_create_listing(school_id)
    end
  end

  def deactivate
    self.update(active: false)
    self.deactivate_listings
    self.deactivate_unit_listings
    self.account.close_school_listing_if_no_properties
  end

  def ban
    self.update(active: false, deleted: true)
    self.ban_listings
    self.ban_unit_listings
    self.account.close_school_listing_if_no_properties
  end

  def delete
    self.update(active: false, deleted: true)
    self.delete_listings
    self.delete_unit_listings
  end

  #######################
  #### PRETTY PRINTS ####
  def pretty_address
    return full_address if self.has_full_address?
    return "New #{self.property_type.singularize} (no address specified)"
  end

  def pretty_distance_to_school(school_id)
    "#{distance_to_school(school_id).round(2)} mi."
  end

  def pretty_distance_to_nearest_school
    list = self.property_schools.order(:distance)
    list.present? ? "#{list.first.distance.round(2)} mi." : ">15 mi."
  end

  def pretty_nearby_schools(distance)
    nearby_schools = self.schools(distance).to_a
    return "Not close to any school." if nearby_schools.empty?
    str = "#{nearby_schools.first.name} (#{nearby_schools.first.property_schools.first.distance.round(2)} mi.)"
    str << " and #{nearby_schools.length - 1} other schools" if nearby_schools.length > 1
    return str
  end

  #############################
  #### LISTINGS UTILITIES #####

  def activate_units
    self.unit_classes.each { |unit| unit.activate(school_ids, self.property_type) }
  end

  def deactivate_listings
    self.listings.where(active: true).update_all(active: false, closed_at: DateTime.now)
  end

  def deactivate_unit_listings
    self.unit_classes.each { |unit| unit.deactivate }
  end

  def ban_listings
    self.listings.where(active: true).update_all(active: false, deleted: true, banned: true, closed_at: DateTime.now)
  end

  def ban_unit_listings
    self.unit_classes.each { |unit| unit.ban }
  end

  def delete_listings
    self.listings.where(active: true).update_all(active: false, deleted: true, closed_at: DateTime.now)
  end

  def delete_unit_listings
    self.unit_classes.each { |unit| unit.delete }
  end

  def find_or_create_property_school(school_id)
    PropertySchool.where(property_id: self.id, school_id: school_id).first_or_create(distance: self.calculate_distance_to_school(school_id))
  end

  def find_or_create_listing(school_id)
    close_date = (self.property_type == 'sublets' ? 30.days.from_now : nil)
    self.listings.where(active: true, school_id: school_id, property_type: self.property_type).first_or_create(will_close_at: close_date)
  end

  def destroy_faraway_property_schools(school_ids)
    self.property_schools.each { |ps| ps.destroy unless school_ids.include? ps.school_id }
  end

  def close_faraway_listings(school_ids)
    self.listings.each { |listing| listing.update(active: false, closed_at: DateTime.now) unless school_ids.include? listing.school_id }
  end

  ############################
  #### LOCATION UTILITIES ####
  def address_changed
    street_address_changed? || city_changed? || state_changed? || postal_code_changed?
  end

  def has_full_address?
    street_address && city && state
  end

  def full_address
    "#{street_address}, #{city} #{state} #{postal_code}"
  end

  def distance_to_school(school_id)
    return self.property_schools.where(school_id: school_id).first.distance
  end

  def ready_for_posting
    latitude && longitude
  end

  def rename_and_redistance
    self.name = pretty_address
    self.redistance
  end

  def redistance
    school_ids = self.calculate_nearby_schools.map{|s| s.id}
    for school_id in school_ids do
      self.find_or_create_property_school(school_id)
      self.find_or_create_listing(school_id) #eventually, this will be done manually (when landlords pick which schools to list at)
      self.unit_classes.each { |unit| unit.find_or_create_listing(school_id, self.property_type) }
    end
    self.destroy_faraway_property_schools(school_ids)
    self.close_faraway_listings(school_ids)
    self.unit_classes.each { |unit| unit.close_faraway_listings(school_ids) }
  end

  def self.near_school(school_id)
    property_ids = Property.joins(:property_schools).where(property_schools: {school_id: school_id}).map(&:id)
    Property.includes(:property_schools, :unit_classes).where(id: property_ids).where.not(property_type: 'campus')
  end

  def schools(distance)
    School.includes(:property_schools).where("property_schools.property_id = #{self.id} AND property_schools.distance <= #{distance.to_i}").order("property_schools.distance ASC")
  end

  #######################################
  #### CALCULATIONS FOR REDISTANCING ####

  def calculate_nearby_schools
    School.joins(:properties).merge(Property.near(self, 15, select: "schools.*")).uniq_by
  end

  def calculate_distance_to_school(school_id)
    self.distance_to(calculate_closest_school_property(school_id))
  end

  def calculate_closest_school_property(school_id)
    Property.where(property_type: 'campus', school_id: school_id).min {|a,b| a.distance_from(self) <=> b.distance_from(self) }
  end

end