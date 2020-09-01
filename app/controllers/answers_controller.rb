class AnswersController < ApplicationController

  def new
    # Tenho que popular essas variáveis caso eu queira ter acesso a elas enquanto estou
    # no show da answer
    @product = Product.find(params[:product_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def create
    puts '====='
    puts params
    puts '====='
    @product = Product.find(params[:product_id])
    @question = Question.find(params[:question_id])
    #@answer = Answer.new(answer_params)
    @answer = @question.build_answer(answer_params)
    
    
    @answer.product = @product
    @answer.question = @question
    @answer.user = current_user
    @answer.save!

    redirect_to @product
  end
  
  private
  
  def answer_params
    params.require(:answer)
          .permit(:content, :user_id, :product_id, :question_id)
  end
end
