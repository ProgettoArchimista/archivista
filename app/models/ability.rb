# Upgrade 2.0.0 inizio
class Ability
  include CanCan::Ability

  def initialize(current_user)
    if current_user.group_id.nil?
      can :manage, :all
    else
      can :manage, :all, :group_id => current_user.group_id
    end
  end
end
# Upgrade 2.0.0 fine
