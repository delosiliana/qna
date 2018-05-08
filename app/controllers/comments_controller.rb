class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  before_action :set_comment, only: [:update, :destroy]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def destroy
    @comment.destroy if current_user.author?(@comment)
  end

  def update
    @comment.update(comment_params) if current_user.author?(@comment)
    @commentable = @comment.commentable
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
end
