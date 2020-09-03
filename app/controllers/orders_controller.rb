class OrdersController < ApplicationController

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
    puts '===='
    puts params
    puts '===='
    @order.save!

    redirect_to [@product, @order], notice: 'Pedido realizado com sucesso!'
  end

  private

  def order_params
    params.require(:order)
          .permit(:discount, :payment_method, :address, :comment, :product_price)
  end
end

