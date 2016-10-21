class Unit < ActiveRecord::Base

  extend HasArchidate
  has_many_archidates

  MAX_LEVEL_OF_NODES = 2

  # Associations

  belongs_to :fond, :counter_cache => true

  has_ancestry :cache_depth => true

  has_many :unit_identifiers
  has_many :unit_other_reference_numbers
  has_many :unit_langs
  has_many :unit_damages
  has_many :unit_urls
# Upgrade 2.0.0 inizio
#  has_many :unit_editors, :order => :edited_at
  has_many :unit_editors, -> { order(:edited_at) }
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

  has_many :rel_unit_sources
  has_many :sources, :through => :rel_unit_sources

  has_many :rel_unit_headings
  has_many :headings, :through => :rel_unit_headings

# Upgrade 2.0.0 inizio
  has_one :sc2
  has_many :sc2_textual_elements
  has_many :sc2_visual_elements
  has_many :sc2_authors
  has_many :sc2_attribution_reasons, :through => :sc2_authors
  has_many :sc2_commissions
  has_many :sc2_commission_names, :through => :sc2_commissions
	has_many :sc2_techniques
  has_many :sc2_scales
# Upgrade 2.0.0 fine
	
  # Virtual attributes

  alias_attribute :name, :title
  alias_attribute :display_name, :title

  # FIXME (anche archimate): usare :format. Verificare dove usato (dopo modifica su pagine member)
  def level_type(short=false)
    short ? suffix = "_short" : suffix = ""
    case ancestry_depth
    when 0
      "#{I18n.t('level_file'+suffix)}"
    when 1
      "#{I18n.t('level_subfile'+suffix)}"
    when 2
      "#{I18n.t('level_subsubfile'+suffix)}"
    end
  end

  # Methods

  def full_path
    fond.path_items
  end

  def is_leaf?
    ancestry_depth == MAX_LEVEL_OF_NODES
  end

  def has_local_siblings?
# Upgrade 2.0.0 inizio
#    siblings.all(:conditions => "fond_id = #{self.fond_id}").count > 1
    siblings.where("fond_id = #{self.fond_id}").count > 1
# Upgrade 2.0.0 fine

  end

  def is_movable_up?
    !is_root?
  end

  def is_movable_down?
    !is_leaf? &&
      has_local_siblings? &&
      !descendants.at_depth(MAX_LEVEL_OF_NODES).exists?
  end

  def is_not_movable?
    !is_movable_up? && !is_movable_down?
  end

  def is_iccd?
    tsk.present?
  end

  def formatted_title
    given_title? ? "[#{title}]" : title
  end

# Upgrade 2.0.0 inizio
#  scope :list, select("id, fond_id, sequence_number, ancestry_depth, reference_number, title, given_title").includes(:preferred_event)
  scope :list, -> { select("id, fond_id, sequence_number, ancestry_depth, reference_number, title, given_title").includes(:preferred_event) }
# Upgrade 2.0.0 fine

  # Methods related to sequence_number

  # Returns a hash of all the units of the *root_fond*,
  # where the key is the unit_id and the value is the display_sequence_number.
  # The hash is empty if the root_fond has no subunits.

  def self.display_sequence_numbers_of(root_fond, index = 0)
    display_sequence_numbers = {}
    if root_fond.has_subunits?
# Upgrade 2.0.0 inizio
=begin
      units = self.all(:select => "id, position, ancestry, ancestry_depth",
        :conditions => "root_fond_id = #{root_fond.id} AND sequence_number IS NOT NULL",
        :order => "sequence_number")
=end
      units = self.select("id, position, ancestry, ancestry_depth").
        where("root_fond_id = #{root_fond.id} AND sequence_number IS NOT NULL").
        order("sequence_number")
# Upgrade 2.0.0 fine
      units.map do |u|
        value = case u.ancestry_depth
                when 0
# Upgrade 2.0.0 inizio
#                  [index += 1].to_s
                  index += 1
                  index.to_s
# Upgrade 2.0.0 fine
                when 1
                  [index, u.position].join(".")
                when 2
                  [index, u.parent.position, u.position].join(".")
                end
        display_sequence_numbers[u.id] = value
      end
    end
    display_sequence_numbers
  end

  # Method to be used in collection actions.
  def display_sequence_number_from_hash(display_sequence_numbers)
    display_sequence_numbers.present? ? display_sequence_numbers[id] : sequence_number
  end

  # Method to be used in member actions.
  def display_sequence_number
    self.class.display_sequence_numbers_of(fond.root)[id] || sequence_number
  end

  def prev_in_sequence
# Upgrade 2.0.0 inizio
#    self.class.find(:first, :select => "id", :conditions => "root_fond_id = #{root_fond_id} AND sequence_number = #{sequence_number-1}")
    self.class.select("id").find_by("root_fond_id = #{root_fond_id} AND sequence_number = #{sequence_number-1}")
# Upgrade 2.0.0 fine

  end

  def next_in_sequence
# Upgrade 2.0.0 inizio
#    self.class.find(:first, :select => "id", :conditions => "root_fond_id = #{root_fond_id} AND sequence_number = #{sequence_number+1}")
    self.class.select("id").find_by("root_fond_id = #{root_fond_id} AND sequence_number = #{sequence_number+1}")
# Upgrade 2.0.0 fine
  end

end
