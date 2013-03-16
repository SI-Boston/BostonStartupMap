class Company < ActiveRecord::Base
  attr_accessible :name, :url, :description, :address, :zip, :latitude, :longitude, :image, :remote_image_url, :twitter_handle, :facebook_handle, :category
  validates_uniqueness_of :name
  mount_uploader :image, ImageUploader
  geocoded_by :full_street_address
  before_create :geocode    

  def category_enum
    # Do not select any value, or add any blank field. RailsAdmin will do it for you.
    ['Startup', 'Accelerator/Incubator', 'Investor', 'Co-working space', 'Hang-out spot']
  end

  def full_street_address
    "#{address}, #{zip}"
  end
end
