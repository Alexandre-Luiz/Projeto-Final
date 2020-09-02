class AnswersController < ApplicationController

  def new
    # Tenho que popular essas variáveis caso eu queira ter acesso a elas enquanto estou
    # no show da answer
    @product = Product.find(params[:product_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def create
    @product = Product.find(params[:product_id])
    @question = Question.find(params[:question_id])
    @answer = @question.build_answer(answer_params)
    
    @answer.product = @product
    @answer.question = @question
    @answer.user = current_user
    if current_user == @product.user
      @answer.save!
      redirect_to @product
    else
      flash.notice = 'Sem autorização para responder sobre esse produto'
      render :new
    end
  end
  
  private
  
  def answer_params
    params.require(:answer)
          .permit(:content, :user_id, :product_id, :question_id)
  end
end
