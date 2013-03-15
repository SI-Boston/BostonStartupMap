class AddTagsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :category, :string
  end
end
