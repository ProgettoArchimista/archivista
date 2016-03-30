class DocumentFormsController < ApplicationController
# Upgrade 2.0.0 inizio
  extend GroupSupport
# Upgrade 2.0.0 fine

  layout "two_columns"

  def index
# Upgrade 2.0.0 inizio
#    @document_forms = DocumentForm.order("name")
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @document_forms = DocumentForm.page(params['page']).accessible_by(current_ability, :read).order("name")
# Upgrade 2.0.0 fine
  end

  def show
# Upgrade 2.0.0 inizio
#    @document_form = DocumentForm.find(params[:id])
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @document_form = DocumentForm.accessible_by(current_ability, :read).find(params[:id])		
# Upgrade 2.0.0 fine
  end

end

