class FondsController < ApplicationController
# Upgrade 2.0.0 inizio
  extend GroupSupport
# Upgrade 2.0.0 fine

  def index
# Upgrade 2.0.0 inizio
#    @fonds = Fond.page(params['page']).roots.includes(:preferred_event).order("name")
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @fonds = Fond.page(params['page']).roots.accessible_by(current_ability, :read).includes(:preferred_event).order("name")
# Upgrade 2.0.0 fine
    render :layout => "two_columns"
  end

  def show
# Upgrade 2.0.0 inizio
#    @fond = Fond.find(params[:id])
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @fond = Fond.accessible_by(current_ability, :read).find(params[:id])
# Upgrade 2.0.0 fine
    @units = @fond.units.list

    if pjax_request?
      render :layout => false
    else
      render :layout => "treeview"
    end
  end

  def tree
# Upgrade 2.0.0 inizio
#    @fond = Fond.find(params[:id])
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @fond = Fond.accessible_by(current_ability, :read).find(params[:id])
# Upgrade 2.0.0 fine
    @root_fond = @fond.is_root? ? @fond : @fond.root

# Upgrade 2.0.0 inizio
#    @nodes = @root_fond.fast_subtree_to_jstree_hash
    @nodes = @root_fond.fast_subtree_to_jstree_hash(group_context_path_get)
# Upgrade 2.0.0 fine

    respond_to do |format|
      format.json { render :json => @nodes }
    end
  end

end

