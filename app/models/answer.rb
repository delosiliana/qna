class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  scope :ordered, -> { order(best: :desc) }

  def best!
    prev_best = question.answers.where(best: true).first
    transaction do
      prev_best&.update!(best: false)
      update!(best: true)
    end
  end
end
