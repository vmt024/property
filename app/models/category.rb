class Category < ActiveRecord::Base
  belongs_to :transactions
end
