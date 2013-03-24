class Company < ActiveRecord::Base
  attr_accessible :name, :url, :description, :address, :zip, :latitude, :longitude, :image, :remote_image_url, :twitter_handle, :facebook_handle, :category
  validates_uniqueness_of :name
  mount_uploader :image, ImageUploader
  geocoded_by :full_street_address
  before_create :geocode    

  def category_enum
     ['Startup', 'Accelerator/Incubator', 'Venture Capitalist', 'Angel Investor', 'Co-working space', 'Hang-out spot', 'Event']
  end

  def full_street_address
    "#{address}, #{zip}"
  end
end
