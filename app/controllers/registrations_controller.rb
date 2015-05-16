class RegistrationsController < Devise::RegistrationsController
  
  def update
    @user = User.find(current_user.id)
    debugger
    if @user.update_with_password(user_params)
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end


  private

    def user_params
      new_params = params.require(:user).permit(:email,
                                              :username, :current_password, :password,
                                              :password_confirmation)
    end
end