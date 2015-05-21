class Ability
  include CanCan::Ability

  

  def initialize(user)

    user ||= User.new

    if user && !user.persisted?
      can :read,    Post, restricted: false
    end

    if user && user.persisted?
      can :read, Post do |post|
        !post.restricted? || post.user_id == user.id || check_collab(post, user)
      end

      can :create, Post, user_id: user.id

      can :update, Post do |post|
        post.user_id == user.id || check_collab(post, user)
      end

      can :destroy, Post, user_id: user.id

      can :create,  Collaboration do |col|
        check_user(col, user)
      end
      
      can :destroy, Collaboration do |col|
        check_user(col, user)
      end
    end

    if user.admin? && user.persisted?
      can :manage, Post
      can :manage, Collaboration
    end
  end

  private

    def check_collab(post, user)
      post.collaborations.map { |c| c.user_id }.include?(user.id)
    end

    def check_user(col, user)
      col.post.user.id == user.id
    end
end
