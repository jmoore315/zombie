class CreateRoommateListings < ActiveRecord::Migration
  def change
    create_table :roommate_listings do |t|
      t.string   :gender
      t.integer  :grad_year
      t.integer  :ideal_rent
      t.date     :occupancy_date
      t.string   :fb_link
      t.string   :telephone
      t.string   :pref_gender
      t.string   :pref_smoking
      t.string   :pref_pets
      t.string   :pref_cleanliness
      t.string   :pref_social
      t.integer  :pref_age
      t.integer  :age
      t.string   :cleanliness
      t.string   :social
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :account_id
      t.boolean  :active
      t.string   :uuid
      t.string   :title
      t.text     :description
      t.boolean  :deleted
      t.string   :first_image_url
      t.timestamps
    end
    add_index :roommate_listings, :account_id
  end
end

