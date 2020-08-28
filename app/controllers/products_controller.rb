class ProductsController < ApplicationController
  
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    puts '======='
    puts params
    puts '======='
    @product = Product.new(product_params)
    @product.user = current_user
    @product.save!
    redirect_to @product, notice: 'Produto colocado a venda com sucesso!'
  end

  private
  
  def product_params
    params.require(:product)
          .permit(:name, :category, :description, :price)
  end
end