class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table  :bookmarks do |t|
    	t.integer   :account_id
      t.integer   :bookmarkable_id
      t.string    :bookmarkable_type
    	t.integer   :school_id
      t.timestamps
    end
    add_index :bookmarks, :account_id
  end
end
