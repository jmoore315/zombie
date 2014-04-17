class Listing < ActiveRecord::Base
	belongs_to :listable, polymorphic: true
	belongs_to :school
	before_create :set_defaults

	def set_defaults
		self.active = true
		self.opened_at = DateTime.now
		self.property_type = self.listable_type if self.property_type == nil
	end

end