class Company < ActiveRecord::Base
  attr_accessible :name, :url, :description, :address, :zip, :latitude, :longitude, :image, :remote_image_url
  validates_uniqueness_of :name
  mount_uploader :image, ImageUploader
end
