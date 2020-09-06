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
    @order.final_price = @order.price_calculation

    @order.save!
    # Tornando o anúncio indisponível após criação do pedido
    @product.disabled!
    redirect_to [@product, @order], notice: 'Pedido realizado com sucesso!'
  end

  private

  def order_params
    params.require(:order)
          .permit(:discount, :payment_method, :address, :comment, :product_price, :final_price)
  end
end

