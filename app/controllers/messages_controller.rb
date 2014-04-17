##
# MessagesController implements the methods necessary for sending Messages.
# 
class MessagesController < ApplicationController

	def send_message
		message = (user_signed_in? ? @current_account.messages.create(message_params) : Message.create(message_params))
		if message
			MessageMailer.message_email(message).deliver
			MessageMailer.message_confirmation(message,current_user).deliver
		end
	end

private
	
	def message_params
		params.require(:message).permit(:messageable_id, :messageable_type, :school_code, 
			:sender_email, :sender_name, :sender_telephone, :content
		)
	end

end