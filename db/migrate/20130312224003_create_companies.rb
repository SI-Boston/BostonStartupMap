class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|

      t.timestamps
      t.string :name, null: false, unique: true
      t.string :url
      t.text :description
      t.string :address, null: false
      t.integer :zip, null: false
      t.float :latitude
      t.float :longitude
      t.string :image
    end
  end
end
