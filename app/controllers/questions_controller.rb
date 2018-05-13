class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@answers)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy if current_user.author?(@question)
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions',
      ApplicationController.render(
        partial: 'questions/question_action',
        locals: { question: @question }
      )
  end

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
