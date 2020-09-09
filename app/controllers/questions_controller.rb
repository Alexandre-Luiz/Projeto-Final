class QuestionsController < ApplicationController
  before_action :company_and_product_check, only: [:new]

  def new
    @product = Product.find(params[:product_id])
    @question = Question.new
  end

  def create
    @product = Product.find(params[:product_id])
    @question = Question.new(question_params)

    @question.user = current_user
    @question.product = @product
    
    if @question.save
      redirect_to @product
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question)
          .permit(:content, :product_id, :user_id)
  end

  def company_and_product_check
    @product = Product.find(params[:product_id])
    if @product.disabled?
      redirect_to products_path, notice: 'Produto inexistente'
    end
    user_domain = current_user.email.split("@").last
    product_owner_domain = @product.user.email.split("@").last
    redirect_to products_path, notice: 'Produto inexistente para fazer pergunta' if user_domain != product_owner_domain
  end
end