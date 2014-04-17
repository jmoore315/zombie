class CreateUnitClasses < ActiveRecord::Migration
  def change
    create_table :unit_classes do |t|
      t.integer  :property_id
      t.integer  :bedrooms
      t.integer  :bathrooms
      t.boolean  :active
      t.integer  :roommates
      t.integer  :size
      t.datetime :lease_from
      t.datetime :lease_until
      t.datetime :list_from
      t.datetime :list_until
      t.integer  :price
      t.boolean  :deleted
      t.boolean  :graduate_only
      t.string   :property_type
      t.timestamps
    end

    add_index :unit_classes, :property_id
  end
end