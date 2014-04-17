class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :current_account
  before_filter :show_navbar_search

  def current_account
  	@current_account = current_user.account if user_signed_in?
  end

  def authenticate_role(roles)
    redirect_to root_url unless @current_account && (@current_account.role == roles || roles.include?(@current_account.role))
  end

  def show_navbar_search
    @show_navbar_search = true unless @current_account && @current_account.role == 'school_admin'
  end

end