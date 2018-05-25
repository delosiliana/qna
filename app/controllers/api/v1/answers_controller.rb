class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: [:show]
  before_action :load_question, only: [:index, :create]
  authorize_resource

  def index
    respond_with @question.answers
  end

  def create
    @answer = Answer.create(answer_params.merge(user: current_resource_owner, question: @question))
    respond_with @answer
  end

  def show
    respond_with @answer
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
