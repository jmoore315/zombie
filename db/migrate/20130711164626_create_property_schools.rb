class CreatePropertySchools < ActiveRecord::Migration
  def change
    create_table :property_schools do |t|
      t.integer :property_id
      t.integer :account_id
      t.float   :distance
      t.boolean :active
      t.timestamps
    end
    add_index :property_schools, :property_id
    add_index :property_schools, :account_id
  end
end