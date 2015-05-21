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
      can :create,  Post,          user_id: user.id
      can :update,  Post do |post|
        post.user_id == user.id || post.collaborations.map { |c| c.user_id }.include?(user.id)
      end
      can :destroy, Post,          user_id: user.id
      can :create,  Collaboration do |col|
        col.post.user.id == user.id
      end
      can :destroy, Collaboration do |col|
        col.post.user.id == user.id
      end
    end

    if user.admin? && user.persisted?
      can :manage, Post
      can :manage, Collaboration
    end
  end
end
