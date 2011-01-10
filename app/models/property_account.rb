class PropertyAccount < ActiveRecord::Base
  validates_presence_of :user_id,:address_1,:address_2,:address_3,:address_4

  has_many :transactions
  
  belongs_to :user

  def property_name
    return [self.address_1,self.address_2].join(" ")
  end
end
