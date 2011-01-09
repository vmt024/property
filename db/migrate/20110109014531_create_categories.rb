class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :description,:limit=>50, :null=>false
      t.integer :parent_id
      t.string :category_type, :limit=>10, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
