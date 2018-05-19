class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :set_comment, only: [:update, :destroy]
  after_action :publish_comment, only: :create

  respond_to :js
  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    respond_with(@comment.destroy)
  end

  def update
    @comment.update(comment_params)
    @commentable = @comment.commentable
    respond_with @comment
  end

  private

  def set_commentable
    @commentable = if params[:answer_id]
      Answer.find(params[:answer_id])
    elsif params[:question_id]
      Question.find(params[:question_id])
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id

    ActionCable.server.broadcast(
      "question-#{question_id}:comments",
        { comment: @comment.to_json } )
  end
end
