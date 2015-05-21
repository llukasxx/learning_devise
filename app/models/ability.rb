class Ability
  include CanCan::Ability

  

  def initialize(user)

    user ||= User.new

    # Non-logged in users
    if user && !user.persisted?
      can :read,    Post, restricted: false
    end

    # Regular users
    if user && user.persisted?
      # User can't read restricted posts, can read own restricted posts, 
      # can read restricted post if he's collaborator
      can :read, Post do |post|
        !post.restricted? || post.user_id == user.id || check_collab(post, user)
      end

      # User can create own post
      can :create, Post, user_id: user.id

      # User can update own post and post where he's collaborator
      can :update, Post do |post|
        post.user_id == user.id || check_collab(post, user)
      end

      # User can destroy own post
      can :destroy, Post, user_id: user.id

      # User can create collaboration on own post
      can :create,  Collaboration do |col|
        check_user(col, user)
      end

      # User can destroy collaborators of his own post
      can :destroy, Collaboration do |col|
        check_user(col, user)
      end
    end

    # Admins can everything
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
