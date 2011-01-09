class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :property_account_id
      t.date :date
      t.string :description,:limit=>100
      t.integer :category_id
      t.decimal :amount, :precision => 8, :scale => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
