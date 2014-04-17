class AddImageableUuidToImage < ActiveRecord::Migration
  def change
  	add_column :images, :imageable_uuid, :string
  end
end
