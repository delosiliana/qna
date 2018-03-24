class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :ordered, -> { order(best: :desc) }

  def best!
    prev_best = question.answers.where(best: true)
    transaction do
      prev_best.first.update!(best: false) unless prev_best.empty?
      update!(best: true)
    end
  end
end
