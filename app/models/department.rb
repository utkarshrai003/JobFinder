class Department < ActiveRecord::Base
	belongs_to :company

	validates_uniqueness_of :name, scope: :company_id
end
