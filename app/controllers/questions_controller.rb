class QuestionsController < ApplicationController

  def new
    @product = Product.find(params[:product_id])
    @question = Question.new
  end

  def create
    @product = Product.find(params[:product_id])
    @question = Question.new(question_params)
  
    @question.user = current_user
    @question.product = @product
    @question.save!

    redirect_to @product
  end

  private

  def question_params
    params.require(:question)
          .permit(:content, :product_id, :user_id)
  end
end