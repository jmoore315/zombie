##
# MarketplaceController implements all methods allowing a User to add, edit, list,
# destroy, or otherwise interact with his MarketplaceItems. Only a user with a "student"
# account may interact with this controller.
# 
class MarketplaceController < ApplicationController
	before_filter :authenticate_user!
	before_filter {|controller| controller.send(:authenticate_role, 'student')}

	def new
		@item = @current_account.marketplace_items.create
		render 'show'
	end

	def show
		@item = @current_account.marketplace_items.find(params[:id])
		@condition = @item.condition
	end

	def update
		@item = @current_account.marketplace_items.find(params[:id])
		@item.update_attributes(marketplace_params)
	end

	def delete
		@item = @current_account.marketplace_items.find(id: params[:id])
		@item.delete
		redirect_to listings_url
	end

	def activate
		@item = @current_account.marketplace_items.find(params[:id])
		@item.activate
		redirect_to listings_url
	end

	def deactivate
		@item = @current_account.marketplace_items.where(id: params[:id].to_i).first
		@item.deactivate
		redirect_to listings_url
	end

	def category
		@item = @current_account.marketplace_items.where(id: params[:id].to_i).first
	end

private
	
	def marketplace_params
		params.require(:marketplace_item).permit(:name, :description, :deleted, :active, :condition, :list_from, :list_until, :price, :category, :subcategory)
	end

end