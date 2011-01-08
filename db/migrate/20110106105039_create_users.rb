class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :limit=>20
      t.string :email, :limit=>50, :null=>false
      t.string :password, :limit=>64, :null=>false
      t.string :salt, :limit=>64, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
