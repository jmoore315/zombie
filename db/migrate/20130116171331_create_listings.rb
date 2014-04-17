class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer  :school_id
      t.integer  :listable_id
      t.string   :listable_type
      t.boolean  :active
      t.boolean  :banned
      t.datetime :opened_at
      t.datetime :closed_at
      t.datetime :will_close_at
      t.string   :property_type
      t.boolean  :deleted
      t.timestamps
    end
    add_index :listings, :school_id
    add_index :listings, [:listable_id, :listable_type]
  end
end