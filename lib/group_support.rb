# Upgrade 2.0.0 inizio
module GroupSupport

  def get_group_from_params(params, group_parameter)
    if params[group_parameter].present?
      if is_numeric_group_id?(params[group_parameter])
        group = Group.find(params[group_parameter])
      else
        group = Group.find_by_short_name(params[group_parameter])
      end
    else
      group = nil
    end
    return group
  end

  def get_group_id_from_params(params, group_parameter)
    if params[group_parameter].present?
      if is_numeric_group_id?(params[group_parameter])
        group_id = params[group_parameter]
      else
        group = Group.find_by_short_name(params[group_parameter])
        if group.nil?
          group_id = -1
        else
          group_id = group.id
        end
      end
    else
      group_id = -1
    end
    return group_id
  end

  def is_numeric_group_id?(ipvalue)
    return value_is_integer_base10?(ipvalue)
  end

  def value_is_numeric?(ipvalue)
    !!(ipvalue.to_s =~ /\A[-+]?[0-9]+(\.[0-9]+)?\z/)
  end

  def value_is_integer_base10?(ipvalue)
    !!(ipvalue.to_s =~ /\A[1-9]{1}([0-9]+)?\z/)
  end

end
# Upgrade 2.0.0 fine
