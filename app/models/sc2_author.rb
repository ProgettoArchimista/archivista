# Upgrade 2.0.0 inizio
class Sc2Author < ActiveRecord::Base
  belongs_to :unit

  has_many :sc2_attribution_reasons
end
# Upgrade 2.0.0 fine
