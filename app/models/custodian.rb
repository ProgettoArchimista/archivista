class Custodian < ActiveRecord::Base

  # Associations

  belongs_to :custodian_type
  has_one :import, :as => :importable

  has_many  :custodian_names
# Upgrade 2.0.0 inizio
=begin
  has_one   :preferred_name, :class_name => 'CustodianName', :conditions => {:qualifier => 'AU', :preferred => true}
  has_many  :other_names, :class_name => 'CustodianName', :conditions => {:preferred => false}
=end
  has_one   :preferred_name, -> { where({:qualifier => 'OT', :preferred => true}) }, :class_name => 'CustodianName'
  has_many  :other_names, -> { where({:preferred => false}) }, :class_name => 'CustodianName'
# Upgrade 2.0.0 fine

  has_many  :custodian_identifiers
  has_many  :custodian_contacts
# Upgrade 2.0.0 inizio
=begin
  has_one   :custodian_headquarter, :class_name => 'CustodianBuilding', :conditions => {:custodian_building_type => 'sede legale'}
  has_many  :custodian_other_buildings, :class_name => 'CustodianBuilding', :conditions => "custodian_building_type != '' AND custodian_building_type != 'sede legale'"
=end
  has_one   :custodian_headquarter, -> { where({:custodian_building_type => 'sede legale'}) }, :class_name => 'CustodianBuilding'
  has_many  :custodian_other_buildings, -> { where("custodian_building_type != '' AND custodian_building_type != 'sede legale'") }, :class_name => 'CustodianBuilding'
# Upgrade 2.0.0 fine
  has_many  :custodian_buildings, :class_name => 'CustodianBuilding'
  has_many  :custodian_owners
  has_many  :custodian_urls
# Upgrade 2.0.0 inizio
#  has_many  :custodian_editors, :order => :edited_at
  has_many  :custodian_editors, -> {order(:edited_at) }
# Upgrade 2.0.0 fine

  has_many  :digital_objects, :as => :attachable

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

  has_many  :rel_custodian_fonds
# Upgrade 2.0.0 inizio
#  has_many  :fonds, :through => :rel_custodian_fonds, :include => :preferred_event, :order => "fonds.name"
# Upgrade 3.0.0 inizio
#  has_many  :fonds, -> { order("fonds.name").includes(:preferred_event)}, :through => :rel_custodian_fonds
  has_many  :fonds, -> {where(published: 1).order("fonds.name").includes(:preferred_event)}, :through => :rel_custodian_fonds
# Upgrade 3.0.0 fine
# Upgrade 2.0.0 fine

  has_many :rel_custodian_sources
  has_many :sources, :through => :rel_custodian_sources

# Upgrade 2.0.0 inizio
#  scope :list, select("custodians.id, custodian_names.name, custodians.updated_at").joins(:preferred_name).includes(:custodian_headquarter)
  scope :list, -> { select("custodians.id, custodian_names.name, custodians.updated_at").joins(:preferred_name).includes(:custodian_headquarter) }
# Upgrade 2.0.0 fine

  # Virtual attributes

  def display_name
    preferred_name.name
  end

  def headquarter_address
    if custodian_headquarter.present?
      [
        custodian_headquarter.address,
        custodian_headquarter.postcode,
        custodian_headquarter.city,
        custodian_headquarter.country
      ].
        delete_if{|fragment| fragment.blank?}.
        join(" ")
    end
  end

end

