# Upgrade 2.0.0 inizio
class GroupImage < ActiveRecord::Base
  belongs_to :group, :foreign_key => "related_group_id"

  acts_as_list

  before_create :generate_access_token

  # Paperclip
  has_attached_file :asset,
    :styles => { :thumb => "130x130>" },
    :url => "#{Settings.group_images_host}/group_images/:access_token/:style.:extension",
    :default_url => "/images/group_image_missing-:style.jpg"

  # Methods
  def is_image?
    ["image/jpeg", "image/jpg", "image/pjpeg"].include?(asset.content_type)
  end

  def is_video?
    return false
  end

  def is_carousel?
    return type == "GroupCarouselImage"
  end

  def is_logo?
    return type == "GroupLogoImage"
  end

  # wrappers degli helper methods
  def group_group_images_path(group)
    # group_group_carousel_images_path(group), group_group_logo_images_path(group)
    return self.send("group_#{self.class.name.underscore}s_path", group)
  end

  def new_group_group_image_path(group)
    # new_group_group_carousel_image_path(group), new_group_group_logo_image_path(group)
    return self.send("new_group_#{self.class.name.underscore}_path", group)
  end

  def edit_group_group_image_path(group)
    # edit_group_group_carousel_image_path(group), edit_group_group_logo_image_path(group)
    return self.send("edit_group_#{self.class.name.underscore}_path", group, self)
  end

  def group_image_description_field_key
    return is_carousel? ? "group_image_carousel_description" : "group_image_logo_url"
  end
  # fine wrappers

  private

  Paperclip.interpolates :access_token  do |attachment, style|
    attachment.instance.access_token
  end
end
# Upgrade 2.0.0 fine
