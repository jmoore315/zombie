# RegistrationsController overrides the 'update' devise method in Devise::RegistrationsController.
# The method now redirects to settings_user_url instead of 

class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

	def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
    else
      clean_up_passwords resource
    end
    @errors = resource.errors.to_a
    @email_or_password = params[:e_or_p]
	end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :code, :role, :company_name, :email, :telephone, :password, :password_confirmation)
    end
  end

end