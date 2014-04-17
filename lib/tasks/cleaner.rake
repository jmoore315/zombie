namespace :cleaner do
  desc "Deactivate all expired listings (sublets, marketplace_items, and roommate_listings) and send emails to their posters."
  
  task expiring_listings: :environment do
  	for property in Property.joins(:listings).where(property_type: 'sublet').where("listings.will_close_at <= '#{Time.now.advance(weeks: 1)}'") do
  		MessageMailer.will_deactivate_notification(property).deliver
  	end
  	for item in MarketplaceItem.joins(:listings).where("listings.will_close_at <= '#{Time.now.advance(weeks: 1)}'") do
  		MessageMailer.will_deactivate_notification(item).deliver
  	end
  	for rl in RoommateListing.joins(:listings).where("listings.will_close_at <= '#{Time.now.advance(weeks: 1)}'") do
  		MessageMailer.will_deactivate_notification(rl).deliver
  	end
  end

  task expired_listings: :environment do
  	for property in Property.joins(:listings).where(property_type: 'sublet').where("listings.will_close_at <= '#{DateTime.now}'") do
  		property.deactivate
  		MessageMailer.deactivated_notification(property).deliver
  	end
  	for item in MarketplaceItem.joins(:listings).where("listings.will_close_at <= '#{DateTime.now}'") do
  		item.deactivate
  		MessageMailer.deactivated_notification(item).deliver
  	end
  	for rl in RoommateListing.joins(:listings).where("listings.will_close_at <= '#{DateTime.now}'") do
  		rl.deactivate
  		MessageMailer.deactivated_notification(rl).deliver
  	end
  end

end
