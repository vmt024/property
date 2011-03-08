class PropertyAccount < ActiveRecord::Base
  validates_presence_of :user_id,:address_2,:address_3,:address_4

  has_many :transactions
  
  belongs_to :user

  def property_name
    if self.nick_name.blank?
      return "#{self.number_of_bedrooms} bedrooms #{self.property_type} at #{self.address_2} in #{self.address_3} area"
    else
      return "[ #{self.nick_name} ]"
    end
    
  end
end
