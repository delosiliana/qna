class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments

  validates :title, :body, presence: true
end
