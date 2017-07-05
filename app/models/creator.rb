class Creator < ActiveRecord::Base

  extend HasArchidate
  has_many_archidates

  def is_person?
    creator_type == 'P'
  end

  def is_family?
    creator_type == 'F'
  end

  def is_corporate?
    creator_type == "C"
  end

  # Associations

  belongs_to :creator_corporate_type

  has_many :creator_names
# Upgrade 2.0.0 inizio
=begin
  has_one  :preferred_name, :class_name => 'CreatorName', :conditions => {:qualifier => 'A', :preferred => true}
  has_many :other_names, :class_name => 'CreatorName', :conditions => {:preferred => false}
=end
  has_one  :preferred_name, -> { where({:qualifier => 'A', :preferred => true}) }, :class_name => 'CreatorName'
  has_many :other_names, -> { where({:preferred => false}) }, :class_name => 'CreatorName'
# Upgrade 2.0.0 fine

  has_many :creator_legal_statuses
  has_many :creator_urls
  has_many :creator_identifiers
  has_many :creator_activities
# Upgrade 2.0.0 inizio
#  has_many :creator_editors, :order => :edited_at
  has_many :creator_editors, -> { order(:edited_at) }
# Upgrade 2.0.0 fine

# Upgrade 2.0.0 inizio
#  has_many :digital_objects, :as => :attachable, :order => :position
  has_many :digital_objects, -> { order(:position) }, :as => :attachable
# Upgrade 2.0.0 fine

# Upgrade 2.0.0 inizio
=begin
  has_one :first_digital_object,
    :as => :attachable,
    :class_name => DigitalObject,
    :conditions => {:position => 1}
=end
  has_one :first_digital_object,
    -> { where({:position => 1}) },
    :as => :attachable,
    :class_name => DigitalObject
# Upgrade 2.0.0 fine

  # Many-to-many associations (rel)

  has_many :rel_creator_creators
  has_many :related_creators, :through => :rel_creator_creators

  has_many :inverse_rel_creator_creators, :class_name => "RelCreatorCreator", :foreign_key => "related_creator_id"
  has_many :inverse_related_creators, :through => :inverse_rel_creator_creators, :source => :creator

  has_many :rel_creator_fonds
# Upgrade 2.0.0 inizio
#  has_many :fonds, :through => :rel_creator_fonds, :include => :preferred_event, :order => "fonds.name"
# has_many :fonds, -> { order("fonds.name").includes(:preferred_event)}, :through => :rel_creator_fonds
# Upgrade 3.0.0 inizio
  has_many :fonds, -> {where(published: 1).order("fonds.name").includes(:preferred_event)}, :through => :rel_creator_fonds
# Upgrade 3.0.0 fine  
# Upgrade 2.0.0 fine

  has_many :rel_creator_institutions
  has_many :institutions, :through => :rel_creator_institutions

  has_many :rel_creator_sources
  has_many :sources, :through => :rel_creator_sources

# Upgrade 2.0.0 inizio
#  scope :list, select("creators.id, creators.creator_type, creator_names.name, creators.residence, creators.updated_at").joins(:preferred_name).includes(:preferred_event)
  scope :list, -> { select("creators.id, creators.creator_type, creator_names.name, creators.residence, creators.updated_at").joins(:preferred_name).includes(:preferred_event) }
# Upgrade 2.0.0 fine



  # Virtual attributes

  def display_name
    preferred_name.name
  end

  def display_name_with_date
    return unless preferred_name
    preferred_event ? "#{h preferred_name.name} (#{preferred_event.full_display_date})" : preferred_name.name
  end

  def full_creator_type
    Creator.human_attribute_name(creator_type.to_sym)
  end

  alias_attribute :value, :name_with_preferred_date

end

