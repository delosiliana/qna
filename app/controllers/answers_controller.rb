class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :best]
  before_action :load_question, only: :create

  after_action :publish_answer, only: :create

  respond_to :js
  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def best
    respond_with(@answer.best!)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("question-#{@question.id}",
      answer: @answer,
      total_votes: @answer.sum,
      attachments: @answer.attachments
    )
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def set_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
