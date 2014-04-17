class PropertySchool < ActiveRecord::Base
	belongs_to :property
	belongs_to :school
	before_create :set_defaults

	def set_defaults
		self.active = true
	end

end