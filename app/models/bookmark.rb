class Bookmark < ActiveRecord::Base
	belongs_to :account
	belongs_to :bookmarkable, polymorphic: true
	validates :account_id, presence: true
	validates :account_id, :uniqueness => { :scope => [:bookmarkable_id, :bookmarkable_type] }

	def delete
		self.destroy
	end

end
 