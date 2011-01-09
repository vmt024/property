class PropertyAccount < ActiveRecord::Base
  validates_presence_of :user_id,:address_1,:address_2,:address_3,:address_4

  belongs_to :user
  
end
