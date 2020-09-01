class ProductsController < ApplicationController
  
  def index
    email_domain = current_user.email.split("@").last 
    @products = Product.joins(:user).where("users.email like ?", "%#{email_domain}")
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    if current_user.user_full_profile? && @product.save
      redirect_to @product, notice: 'Produto colocado a venda com sucesso!'
    else
      flash.alert = 'Por favor, complete o perfil para cadastrar produto'
      render :new
    end
  end

  def search
    email_domain = current_user.email.split("@").last 
    @products = Product.joins(:user).where("users.email like ?", "%#{email_domain}")
                                    .where('products.name LIKE ? OR products.category LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
    #@products = Product.where('name LIKE ? OR category LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
    render :index
  end


  private
  
  def product_params
    params.require(:product)
          .permit(:name, :category, :description, :price)
  end
end