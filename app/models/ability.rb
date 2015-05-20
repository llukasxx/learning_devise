class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.persisted?
      can :destroy, Post, user_id: user.id
      can :update,  Post, user_id: user.id
      can :create,  Post, user_id: user.id
    end

    if !user.nil? && user.admin? && user.persisted?
      can :manage, Post
    end
  end
end
