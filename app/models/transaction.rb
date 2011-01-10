class Transaction < ActiveRecord::Base
  belongs_to :property, :class_name => 'PropertyAccount', :foreign_key => 'property_account_id'
  has_one :category
end
