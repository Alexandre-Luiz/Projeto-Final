class UsersController < ApplicationController
  before_action :check_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end
  
  private

  def check_user
    @user = User.find(params[:id])
    user_domain = current_user.email.split("@").last
    profile_domain = @user.email.split("@").last
    redirect_to root_path, notice: 'Usuário Inexistente' if user_domain != profile_domain
  end
end