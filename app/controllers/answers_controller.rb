class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def best
    if current_user.author?(@answer.question)
      @answer.best!
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
