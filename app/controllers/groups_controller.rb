# Upgrade 2.0.0 inizio
class GroupsController < SiteController

  def index
    @groups = Group.page(params['page']).order("name")
  end

  def show
    current_group_identifier_set(params[:id])
    index_action
    render "site/index"
  end

  def credits
    current_group_identifier_set(params[:group_id])
    @group = GroupsController.get_group_from_params(params, :group_id)
  end

# override della funzione in ApplicationController, necessario perche' qui il parametro del gruppo e' [:id] e non [:group_id]
  def current_user
    user = User.new
    group_id = GroupsController.get_group_id_from_params(params, :id)
    if group_id != -1
      user.group_id = group_id
    end
    return user
  end
end
# Upgrade 2.0.0 fine
