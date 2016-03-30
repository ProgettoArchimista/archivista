class SiteController < ApplicationController

# Upgrade 2.0.0 inizio
  extend GroupSupport
# Upgrade 2.0.0 fine

  def index
# Upgrade 2.0.0 inizio
=begin
# originale
    @fonds_count = Fond.roots.count
    @creators_count = Creator.count
    @custodians_count = Custodian.count

    @fonds = Fond.roots.order("name").limit(5)
    @creators = Creator.list.order("name").limit(5)
    @custodians = Custodian.list.order("name").limit(5)
=end
    index_action
# Upgrade 2.0.0 fine
  end

# Upgrade 2.0.0 inizio
  def index_action
    @fonds_count = Fond.roots.accessible_by(current_ability, :read).count
    @creators_count = Creator.accessible_by(current_ability, :read).count
    @custodians_count = Custodian.accessible_by(current_ability, :read).count
    @projects_count = Project.accessible_by(current_ability, :read).count

    @group = SiteController.get_group_from_params(params, :id)
    if @group.nil?
      @carousel_images = GroupCarouselImage.order("group_id,position")
      @group_logo_images = nil
    else
      @carousel_images = @group.carousel_images.order("position")
      @group_logo_images = @group.logo_images.order("position")
    end
  end
# Upgrade 2.0.0 fine
end

