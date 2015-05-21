class CollaborationsController < ApplicationController
  before_action :authenticate_user!, except: [:edit]

  def edit
    @post = Post.find(params[:id])
    @collaborations = @post.collaborations
    @collaboration = Collaboration.new(post_id: @post.id)
    active_cols = @collaborations.map { |c| c.user.id }
    active_cols << @post.user_id
    @users = User.where.not(id: active_cols)
  end

  def create
    @collaboration = Collaboration.new(collaboration_params)
    authorize! :create, @collaboration
    if @collaboration.save
      redirect_to edit_collaboration_path(id: @collaboration.post_id)
    end
  end

  def destroy
    @collaboration = Collaboration.find(params[:id])
    authorize! :destroy, @collaboration
    if @collaboration.destroy
      redirect_to edit_collaboration_path(id: @collaboration.post_id)
    end
  end


  private

    def collaboration_params
      params.require(:collaboration).permit(:post_id, :user_id)
    end

end
