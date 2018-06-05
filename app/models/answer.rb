class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  after_commit :notice_subscribers, on: :create

  scope :ordered, -> { order(best: :desc) }

  def best!
    prev_best = question.answers.where(best: true).first
    transaction do
      prev_best&.update!(best: false)
      update!(best: true)
    end
  end

  def notice_subscribers
    NotifySubscribersJob.perform_later(question)
  end
end
