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

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if current_user == @product.user && @product.update(product_params)
      redirect_to @product, notice: 'Edição feita com sucesso.'
    else
      flash.alert = 'Sem autorização para editar este anúncio.'
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if current_user == @product.user
      @product.destroy
      redirect_to products_path
    else
      flash.alert = 'Sem autorização para apagar este anúncio.'
      render :show 
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
          .permit(:name, :category, :description, :price, :user_id)
  end

end