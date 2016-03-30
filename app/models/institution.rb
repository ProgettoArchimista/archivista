class Institution < ActiveRecord::Base

  belongs_to :updater,  :class_name => "User", :foreign_key => "updated_by"
# Upgrade 2.0.0 inizio
#  has_many :institution_editors, :dependent => :destroy, :order => :edited_at
  has_many :institution_editors, -> { order(:edited_at) }, :dependent => :destroy
# Upgrade 2.0.0 fine
  
  has_many :rel_creator_institutions
  has_many :creators, :through => :rel_creator_institutions

end

