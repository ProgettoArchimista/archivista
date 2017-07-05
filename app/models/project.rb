class Project < ActiveRecord::Base

  # Associations

# Upgrade 2.0.0 inizio
#  has_many  :project_credits, :dependent => :destroy
# Upgrade 2.0.0 fine
  has_many  :project_urls, :dependent => :destroy
# Upgrade 2.0.0 inizio
=begin 1.2.1
  has_many  :project_managers, :class_name => 'ProjectCredit', :conditions => {:credit_type => 'PM'}
  has_many  :project_stakeholders, :class_name => 'ProjectCredit', :conditions => {:credit_type => 'PS'}
=end
  has_many  :project_managers, :dependent => :destroy
  has_many  :project_stakeholders, :dependent => :destroy
# Upgrade 2.0.0 fine

  # Many-to-many associations (rel)

  has_many :rel_project_fonds, :dependent => :destroy, :autosave => true
# Upgrade 2.0.0 inizio
#  has_many :fonds, :through => :rel_project_fonds, :include => :preferred_event, :order => "fonds.name"
#  has_many :fonds, -> { order("fonds.name").includes(:preferred_event) }, :through => :rel_project_fonds
# Upgrade 3.0.0 inizio
  has_many :fonds, -> { where(published: 1).order("fonds.name").includes(:preferred_event) }, :through => :rel_project_fonds
# Upgrade 3.0.0 fine
# Upgrade 2.0.0 fine

  # Virtual attributes
  alias_attribute :display_name, :name

  def display_date
    if start_year == end_year
      "#{start_year.to_s}"
    else
      "#{start_year.to_s}-#{end_year.to_s}"
    end
  end

end

