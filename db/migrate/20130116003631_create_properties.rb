class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer  :account_id
      t.text     :description
      t.string   :property_type
      t.boolean  :pets_allowed
      t.boolean  :water_included
      t.boolean  :air_conditioning
      t.boolean  :electric_included
      t.boolean  :active
      t.string   :street_address
      t.string   :city
      t.string   :state
      t.string   :postal_code
      t.string   :name
      t.float    :latitude
      t.float    :longitude
      t.boolean  :parking
      t.boolean  :television
      t.boolean  :internet
      t.boolean  :deleted
      t.boolean  :gas_included
      t.boolean  :smoking
      t.boolean  :furnished
      t.string   :uuid
      t.datetime :owner_fblike_time
      t.boolean  :graduate_only
      t.integer  :school_id
      t.boolean  :central_air
      t.string   :first_image_url
      t.timestamps
    end

    add_index :properties, :account_id
  end
end