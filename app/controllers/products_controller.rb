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
    puts '====='
    puts params
    puts '====='
    @product = Product.create(product_params)
    redirect_to @product, notice: 'Produto colado a venda com sucesso'
  end

  private
  
  def product_params
    params.require(:product)
          .permit(:name, :category, :description, :price)
  end
end