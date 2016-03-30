class CreatorsController < ApplicationController
# Upgrade 2.0.0 inizio
  extend GroupSupport
# Upgrade 2.0.0 fine

  layout "two_columns"

  def index
# Upgrade 2.0.0 inizio
#    @creators = Creator.page(params['page']).list.order("name")
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @creators = Creator.page(params['page']).list.accessible_by(current_ability, :read).order("name")
# Upgrade 2.0.0 fine
  end

  def show
# Upgrade 2.0.0 inizio
#    @creator = Creator.find(params[:id])
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @creator = Creator.accessible_by(current_ability, :read).find(params[:id])		
# Upgrade 2.0.0 fine
  end

end

