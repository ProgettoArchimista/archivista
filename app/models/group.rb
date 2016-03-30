class Group < ActiveRecord::Base
  has_many :carousel_images, :dependent => :destroy, :class_name => 'GroupCarouselImage', :foreign_key => "related_group_id"
  has_many :logo_images, :dependent => :destroy, :class_name => 'GroupLogoImage', :foreign_key => "related_group_id"
end