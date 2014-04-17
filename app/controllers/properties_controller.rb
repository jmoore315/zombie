##
# PropertiesController implements methods allowing a user to add, edit, list,
# destroy, or otherwise interact with his properties.
#
class PropertiesController < ApplicationController
	before_filter :authenticate_user!
	before_filter {|controller| controller.send(:authenticate_role, ['student','landlord'])}

	def new
		@property = @current_account.properties.create
		unit = @property.unit_classes.create(graduate_only: @property.graduate_only, property_type: @property.property_type)
		render '/properties/show'
	end

	def show
		@property = @current_account.properties.find(params[:id].to_i)
		redirect_to root_url unless @property.present?
		@image = Image.new
	end

	def update
		if params[:property].present?
			@property = @current_account.properties.find(params[:id])
			@property.update(property_params)
		end
		if params[:unit_class].present?
			@unit_class = @current_account.unit_classes.find(params[:id])
			@unit_class.update(unit_class_params)
		end
		if params[:like].present? && params[:id].present?
			@property = Property.find(params[:id])
			if params[:like] == "true" && @property.owner_fblike_time == nil
				@property.update(owner_fblike_time: DateTime.now)
			end
		end
	end

	def add_unit
		property = @current_account.properties.find(params[:property])
		@unit = property.unit_classes.create(graduate_only: @property.graduate_only, property_type: @property.property_type)
	end

	def remove_unit
		@unit = @current_account.unit_classes.find(params[:id])
		@unit.delete
	end

	def activate
		@property = Property.find(params[:id])
		active, errors = @property.activate
		redirect_to listings_url
	end

	def deactivate
		@property = Property.find(params[:id])
		@property.deactivate
		redirect_to listings_url
	end

	def delete
		@property = @current_account.properties.find(params[:id])
		@property.delete
		redirect_to listings_url
	end

private

	def property_params
		params.require(:property).permit(:active, :deleted, :name, :description, :owner_fblike_time, :street_address, :city, :state, :postal_code, :water_included, :electric_included, :gas_included, :air_conditioning, :internet, :television, :parking, :pets_allowed, :smoking, :furnished, :graduate_only, :central_air)
	end

	def unit_class_params
		params.require(:unit_class).permit(:active, :deleted, :bathrooms, :bedrooms, :size, :description, :roommates, :lease_from, :lease_until, :list_from, :list_until, :price)
	end

end