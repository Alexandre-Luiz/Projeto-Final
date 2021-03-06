class OrdersController < ApplicationController
  before_action :must_be_seller_or_buyer, only: [:show]

  def show
    @product = Product.find(params[:product_id])
    @order = Order.find(params[:id])
  end

  def new
    @product = Product.find(params[:product_id])
    @order = Order.new
  end

  def create
    @product = Product.find(params[:product_id])
    @order = Order.new(order_params)
    
    @order.user = current_user
    @order.product = @product
    @order.final_price = @order.price_calculation

    if @order.save
      # Tornando o anúncio indisponível após criação do pedido
      @product.disabled!
      redirect_to [@product, @order], notice: 'Pedido realizado com sucesso!'
    else
      render :new
    end
  end

  def accept
    @order = Order.find(params[:id])
    @order.completed!
    @order.save!
    redirect_to user_path(id: current_user.id), notice: 'Venda finalizada com sucesso!'
  end

  def decline
    @order = Order.find(params[:id])
    @product = @order.product
    @product.enabled!
    @order.canceled!
    @order.save!
    redirect_to user_path(id: current_user.id), notice: 'Oferta negada com sucesso. Seu produto está disponível para compra novamente.'
  end

  private

  def order_params
    params.require(:order)
          .permit(:discount, :payment_method, :address, :comment, :product_price, :final_price)
  end

  def must_be_seller_or_buyer
    @product = Product.find(params[:product_id])
    @order = @product.order
    if current_user != @product.user && current_user != @order.user
      redirect_to products_path, notice: 'Produto inexistente'
    end
  end
end

