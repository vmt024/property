class Transaction < ActiveRecord::Base
  belongs_to :property, :class_name => 'PropertyAccount', :foreign_key => 'property_account_id'
  has_one :category

  def self.type_desc(tp)
    case tp
    when 'Debit'
      return 'Money In'
    when 'Credit'
      return 'Money Out'
    else
      return 'error'
    end
  end
end
