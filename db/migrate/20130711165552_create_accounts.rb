class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
			t.string   :name
			t.string   :code
			t.boolean  :active
			t.string   :role
			t.string   :telephone
			t.string   :nickname
			t.string   :uuid
			t.string   :email
			t.datetime :deactivated_at
			t.string   :first_image_url
      t.timestamps
    end
  end
end