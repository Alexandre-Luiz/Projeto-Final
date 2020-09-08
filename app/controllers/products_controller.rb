class ProductsController < ApplicationController
  before_action :must_be_same_company, only: [:show]

  def index
    email_domain = current_user.email.split("@").last 
    @products = Product.joins(:user).where("users.email like ?", "%#{email_domain}")
                                    .enabled
    # Ao invés do scope do enum, poderia usar - where(status: 'enabled')
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
                                    .enabled
    #@products = Product.where('name LIKE ? OR category LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
    render :index
  end

  def my_products
    @user = current_user
    @products = @user.products
  end

  def my_order
    @user = current_user
    @product = Product.find(params[:product_id]) 
    @order = @product.order
  end

  
  def my_transactions
    @user = current_user
    @products = @user.products
    @orders = Order.all
  end


  private
  
  def product_params
    params.require(:product)
          .permit(:name, :category, :description, :price, :user_id)
  end

  def must_be_same_company
    @product = Product.find(params[:id])
    user_domain = current_user.email.split("@").last
    product_owner_domain = @product.user.email.split("@").last
    redirect_to products_path, notice: 'Produto inexistente' if user_domain != product_owner_domain
  end

  def must_be_seller
    @product = Product.find(params[:id])
    redirect_to products_path if @product.user != current_user
  end
end