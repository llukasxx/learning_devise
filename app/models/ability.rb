class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new

    if user && !user.persisted?
      can :read,    Post, restricted: false
    end

    if user && user.persisted?
      can :read,    Post do |post|
        !post.restricted? || post.user_id == user.id
      end
      can :destroy, Post, user_id: user.id
      can :update,  Post, user_id: user.id
      can :create,  Post, user_id: user.id
    end

    if user.admin? && user.persisted?
      can :manage, Post
    end
  end
end
