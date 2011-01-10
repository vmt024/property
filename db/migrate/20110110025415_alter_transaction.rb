class AlterTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :transaction_type, :string, :limit=>10
  end

  def self.down
    remove_column :transactions, :transaction_type
  end
end
