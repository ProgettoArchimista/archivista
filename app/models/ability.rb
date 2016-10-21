# Upgrade 2.0.0 inizio
class Ability
  include CanCan::Ability

# Upgrade 2.2.0 inizio
=begin
  def initialize(current_user)
    if current_user.group_id.nil?
      can :manage, :all
    else
      can :manage, :all, :group_id => current_user.group_id
    end
  end
=end
  def initialize(current_user)
    if current_user.group_id.nil?
      can :read, Fond, :trashed => false
      can :read, [Creator, Custodian, Source, DigitalObject, Institution, DocumentForm, Project, Editor]
    else
      can :read, Fond, :trashed => false, :group_id => current_user.group_id
      can :read, [Creator, Custodian, Source, DigitalObject, Institution, DocumentForm, Project, Editor], :group_id => current_user.group_id
    end
  end
# Upgrade 2.2.0 fine
end
# Upgrade 2.0.0 fine
