##
# SchoolAdminController contains methods allowing school administrators to manage
# settings, collect data, and ban bad landlords
#
class SchoolAdminController < ApplicationController
	before_filter :authenticate_user!
	before_filter :authenticate_landlord

	def dashboard
	end

	def analytics
		@tab_name = "analytics"
		params["object"] ||= 'Listing'
		params["function"] ||= 'Active'
		params["timescale"] ||= 'Daily'
		@object    = params["object"]    if School.analytics_objects.include? params["object"]
		@function  = params["function"]  if School.analytics_functions.include? params["function"]
		@timescale = params["timescale"] if School.analytics_timescales.include? params["timescale"]
		@listing_array, @x_axis = @current_account.school.filter_listings(@object,@function,@timescale)
	end

	def monitor
		@tab_name = "landlord_monitor"
		#@landlords = Account.filter()
		school = School.where(code: @current_account.code).first.id
		units = UnitClass.filter(school, property_type: "rentals")
		@landlord_table = {}
		units.each do |unit|
			landlord = unit.property.account.name
			@landlord_table[landlord] ||= []
			@landlord_table[landlord] << unit
		end
	end

	def authenticate_landlord
		render file:'public/404' unless @current_account.role == 'school_admin' && @current_account.code == params[:school_code]
	end

private

end