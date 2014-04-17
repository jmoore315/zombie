class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :account_id
      t.integer :messageable_id
      t.string  :messageable_type
      t.text    :content
      t.string  :sender_email
      t.string  :sender_name
      t.string  :sender_telephone
      t.string  :school_code
      t.timestamps
    end
    add_index :messages, :account_id
    add_index :messages, [:messageable_id, :messageable_type]
  end
end