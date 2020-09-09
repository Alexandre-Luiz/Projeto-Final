class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:role, :department, :name])
  end

  def must_be_same_company
    @product = Product.find(params[:id])
    if @product.blank?
      @product = Product.find(params[:product_id])
    end
    user_domain = current_user.email.split("@").last
    product_owner_domain = @product.user.email.split("@").last
    redirect_to products_path, notice: 'Produto inexistente' if user_domain != product_owner_domain
  end

end
