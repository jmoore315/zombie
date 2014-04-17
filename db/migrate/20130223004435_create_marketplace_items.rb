class CreateMarketplaceItems < ActiveRecord::Migration
  def change
    create_table :marketplace_items do |t|
			t.integer  :account_id
			t.string   :name
			t.text     :description
			t.string   :category
			t.string   :subcategory
			t.boolean  :deleted
			t.boolean  :active
			t.string   :uuid
			t.string   :condition
			t.datetime :list_from
			t.datetime :list_until
			t.integer  :price
			t.string   :first_image_url
      t.timestamps
    end
    add_index :marketplace_items, :account_id
  end
end
