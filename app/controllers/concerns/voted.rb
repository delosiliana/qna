module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voted, only: [:vote_up, :vote_down]
  end

  def vote_up
    if @vote_obj.vote?(current_user, 1) || current_user.author?(@vote_obj)
      render json: 'You already voted', status: 422
    else
      @vote_obj.vote(current_user, 1)
      render json: @vote_obj.votes.sum(:count)
    end
  end

  def vote_down
    if @vote_obj.vote?(current_user, -1) || current_user.author?(@vote_obj)
      render json: 'You already voted', status: 422
    else
      @vote_obj.vote(current_user, -1)
      render json: @vote_obj.votes.sum(:count)
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voted
    @vote_obj = model_klass.find(params[:id])
  end
end

