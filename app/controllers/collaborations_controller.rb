class CollaborationsController < ApplicationController
  before_action :authenticate_user!, except: [:edit]

  def edit
    @post = Post.find(params[:id])
    @collaborations = @post.collaborations
    @collaboration = Collaboration.new
    used_cols = @collaborations.map { |c| c.user.id }
    @users = User.where.not(id: used_cols)
  end

  def create
    @collaboration = Collaboration.new(collaboration_params)
    if @collaboration.save
      redirect_to edit_collaboration_path(id: @collaboration.post_id)
    end
  end

  def destroy
    @collaboration = Collaboration.find(params[:id])
    if @collaboration.destroy
      redirect_to edit_collaboration_path(id: @collaboration.post_id)
    end
  end


  private

    def collaboration_params
      params.require(:collaboration).permit(:post_id, :user_id)
    end

end
