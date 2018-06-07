class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user: user)
  end
end
