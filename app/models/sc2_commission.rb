# Upgrade 2.0.0 inizio
class Sc2Commission < ActiveRecord::Base
  belongs_to :unit

  has_many :sc2_commission_names
end
# Upgrade 2.0.0 fine
