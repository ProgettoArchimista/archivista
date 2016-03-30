class RelCreatorCreator < ActiveRecord::Base

  # Associations

  belongs_to :creator
  belongs_to :related_creator, :class_name => "Creator"
  belongs_to :creator_association_type

  def inverse_association
# Upgrade 2.0.0 inizio
#    creator.inverse_rel_creator_creators.find(:first, :conditions => "creator_id = #{self.related_creator_id}")
    creator.inverse_rel_creator_creators.find_by("creator_id = #{self.related_creator_id}")
# Upgrade 2.0.0 fine
  end

end

