class ApplicationController < ActionController::Base
# Upgrade 2.0.0 inizio

  extend GroupSupport

  helper_method :current_group_identifier_get, :group_context_path_get,
                :current_context_root_path, :current_context_search_path, :current_context_searchunavailable_url,
                :current_context_fonds_path,
                :current_context_fond_units_path, :current_context_fond_unit_path, :current_context_fond_unit_url,
                :current_context_creators_path,
                :current_context_custodians_path,
                :current_context_institutions_path,
                :current_context_document_forms_path,
                :current_context_projects_path,
                :current_context_object_path, :current_context_object_url
  helper_method :isSearchAvailable?
# Upgrade 2.0.0 fine

  protect_from_forgery

# Upgrade 2.0.0 inizio
# --------------------------------------
  def current_ability
    current_ability ||= Ability.new(current_user)
    return current_ability
  end

  def current_user
    user = User.new
    group_id = ApplicationController.get_group_id_from_params(params, :group_id)
    if group_id != -1
      user.group_id = group_id
    end
    return user
  end

# --------------------------------------
  def current_group_identifier_set(group_identifier)
    if group_identifier.nil?
      @current_group_identifier = -1
    else
      @current_group_identifier = group_identifier
    end
  end

# helper methods inizio
  def isSearchAvailable?
    adapter = ActiveRecord::Base.configurations[Rails.env]['adapter']
    return (adapter == "mysql") || (adapter == "mysql2")
  end


  def current_group_identifier_get
    return @current_group_identifier.nil? ? -1 : @current_group_identifier
  end

  def group_context_path_get
    return prv_is_group_context? ? "/groups/" + current_group_identifier_get.to_s : ""
  end

  def current_context_root_path
    return prv_is_group_context? ? group_context_path_get + "/" : "/"
  end

  def current_context_search_path
    return prv_is_group_context? ? group_search_path(current_group_identifier_get) : search_path
  end

  def current_context_searchunavailable_url
    return prv_is_group_context? ? group_searchunavailable_url(current_group_identifier_get) : searchunavailable_url
  end

  def current_context_fonds_path
    return prv_is_group_context? ? group_fonds_path(current_group_identifier_get) : fonds_path
  end

  def current_context_fond_units_path
    return prv_is_group_context? ? group_fond_units_path(current_group_identifier_get) : fond_units_path
  end
  def current_context_fond_unit_path(fond_id, unit)
    return prv_is_group_context? ? group_fond_unit_path(current_group_identifier_get, fond_id, unit) : fond_unit_path(fond_id, unit)
  end
  def current_context_fond_unit_url(fond_id, unit)
    return prv_is_group_context? ? group_fond_unit_url(current_group_identifier_get, fond_id, unit) : fond_unit_url(fond_id, unit)
  end

  def current_context_creators_path
    return prv_is_group_context? ? group_creators_path(current_group_identifier_get) : creators_path
  end

  def current_context_custodians_path
    return prv_is_group_context? ? group_custodians_path(current_group_identifier_get) : custodians_path
  end

  def current_context_institutions_path
    return prv_is_group_context? ? group_institutions_path(current_group_identifier_get) : institutions_path
  end

  def current_context_document_forms_path
    return prv_is_group_context? ? group_document_forms_path(current_group_identifier_get) : document_forms_path
  end

  def current_context_projects_path
    return prv_is_group_context? ? group_projects_path(current_group_identifier_get) : projects_path
  end


  def current_context_object_path(object)
    return prv_is_group_context? ? send("group_#{object.class.name.underscore}_path", current_group_identifier_get, object) : send("#{object.class.name.underscore}_path", object)
  end
  def current_context_object_url(object)
    return prv_is_group_context? ? send("group_#{object.class.name.underscore}_url", current_group_identifier_get, object) : send("#{object.class.name.underscore}_url", object)
  end
# helper methods fine

  private

  def prv_is_group_context?
    return current_group_identifier_get != -1
  end

# Upgrade 2.0.0 fine
end

