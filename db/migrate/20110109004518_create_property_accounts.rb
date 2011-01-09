class CreatePropertyAccounts < ActiveRecord::Migration
 
  def self.up
    create_table :property_accounts do |t|
      t.integer :user_id, :null=>false
      t.string :address_1, :limit=>50
      t.string :address_2, :limit=>50
      t.string :address_3, :limit=>50
      t.string :address_4, :limit=>50
      t.string :post_code, :limit=>4
      t.string :property_type, :limit=>15
      t.integer :number_of_bedrooms
      t.timestamps
    end
  end

  def self.down
    drop_table :property_accounts
  end
end
