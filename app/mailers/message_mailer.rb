class MessageMailer < ActionMailer::Base

	def message_email(message)
		messageable = message.messageable
		@sender_name = message.sender_name || message.sender_email
		@sender_telephone = message.sender_telephone
		@message_content = message.content
		@message = message
		@school_code = message.school_code
		if message.messageable_type == 'UnitClass'
			property = messageable.property
			@property_type = property.property_type
			@link = view_property_url(id: @message.messageable_id, host: "www.uhoused.com", property_type: @property_type, school_code: @school_code)
			recipient = property.account
			@subject = "uHoused Message About #{property.pretty_address}" if @property_type == 'rentals'
			@subject = "uHoused Message About Your Sublet" if @property_type == 'sublets'
		elsif message.messageable_type == 'MarketplaceItem'
			@link = view_item_url(id: @message.messageable_id, host: "www.uhoused.com", school_code: @school_code)
			recipient = messageable.account
			@subject = "uHoused Message About #{messageable.name}"
		elsif message.messageable_type == 'RoommateListing'
			@link = view_roommate_listing_url(id: @message.messageable_id, host: "www.uhoused.com", school_code: @school_code)
			recipient = messageable.account
			@subject = "uHoused Message About Your Roommate Profile"
		end
		mail(to: recipient.email, subject: @subject, reply_to:"#{@sender_name} <#{message.sender_email}>", from: "#{@sender_name} <donotreply@uhoused.com>")
	end

	def message_confirmation(message, current_user)
		@messageable = message.messageable
		if message.messageable_type == 'UnitClass'
			@property = message.messageable.property
		end
		@message_content = message.content
		mail(to: message.sender_email, subject: "Message Confirmation", from:"uHoused Message Confirmation <donotreply@uhoused.com>")
	end

	def will_deactivate_notification(posting)
		poster_email = posting.account.email
		@posting_name = "sublet" if posting.class == Property
		@posting_name = "marketplace item" if posting.class == MarketplaceItem
		@posting_name = "roommate profile" if posting.class == RoommateListing
		mail(to: poster_email, subject: "7 days to renew your uHoused listing", from: "uHoused <donotreply@uhoused.com>")
	end

	def deactivated_notification(posting)
		poster_email = posting.account.email
		@posting_name = "sublet" if posting.class == Property
		@posting_name = "marketplace item" if posting.class == MarketplaceItem
		@posting_name = "roommate profile" if posting.class == RoommateListing
		mail(to: poster_email, subject: "7 days to renew your uHoused listing", from: "uHoused <donotreply@uhoused.com>")
	end


end