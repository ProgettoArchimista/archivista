class UnitsController < ApplicationController
# Upgrade 2.0.0 inizio
  extend GroupSupport
# Upgrade 2.0.0 fine

  def index
# Upgrade 2.0.0 inizio
#    @fond = Fond.select("id, name").find(params[:fond_id])
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @fond = Fond.accessible_by(current_ability, :read).select("id, name").find(params[:fond_id])
# Upgrade 2.0.0 fine
    @units = @fond.units.list
    @sequence_numbers = Unit.display_sequence_numbers_of(@fond.root)

    if pjax_request?
      render :list, :layout => false
    else
# Upgrade 2.0.0 inizio
=begin
      if @units.size.zero?
        redirect_to fond_url(@fond)
      else
        redirect_to fond_unit_path(@fond, @units.first)
      end
=end
      if @units.size.zero?
        render "units/list", :layout => "treeview"
      else
        redirect_to current_context_fond_unit_path(@fond, @units.first)
      end
# Upgrade 2.0.0 fine
    end
  end

  # OPTIMIZE: forse la route potrebbe essere non nested => units/:id
  def show
    @unit = Unit.find(params[:id])

    raise ActiveRecord::RecordNotFound if @unit.fond_id.to_i != params[:fond_id].to_i

    if pjax_request?
      render :layout => false
    else
# Upgrade 2.0.0 inizio
#      @fond = Fond.select("id, name").find(params[:fond_id])
      current_group_identifier_set(params[:group_id])
      @group = SiteController.get_group_from_params(params, :group_id)

      @fond = Fond.accessible_by(current_ability, :read).select("id, name").find(params[:fond_id])
# Upgrade 2.0.0 fine

      @units = @fond.units.list
      @sequence_numbers = Unit.display_sequence_numbers_of(@fond.root)
      render :layout => "treeview"
    end
  end

  def list
# Upgrade 2.0.0 inizio
#    @fond = Fond.select("id, name").find(params[:fond_id])
    current_group_identifier_set(params[:group_id])
    @group = SiteController.get_group_from_params(params, :group_id)

    @fond = Fond.accessible_by(current_ability, :read).select("id, name").find(params[:fond_id])
# Upgrade 2.0.0 fine
    @units = @fond.units.list
    @sequence_numbers = Unit.display_sequence_numbers_of(@fond.root)
    render :layout => false
  end
end