class Category < ActiveRecord::Base
  belongs_to :transactions

  def self.category_desc(id)
    return Category.find(id).description
  rescue=>e
    logger.error("Error::Category.rb::category_desc")
    logger.error(e)
    return 'Error'
  end


end
