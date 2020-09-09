class UsersController < ApplicationController
  before_action :check_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end
  
  private

  def check_user
    @user = User.find(params[:id])
    redirect_to root_path, notice: 'Usuário Inexistente' if @user != current_user
  end
end