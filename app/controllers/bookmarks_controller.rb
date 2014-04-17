# controller actions should only be available for students

class BookmarksController < ApplicationController

	def create
		@bookmark = @current_account.bookmarks.create(account_id: params[:account_id], bookmarkable_id: params[:bookmarkable_id], bookmarkable_type: params[:bookmarkable_type], school_id: params[:school_id])
	end

	def delete
		@bookmark = @current_account.bookmarks.find(params[:id])
		@bookmark.delete
	end



end