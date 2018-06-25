class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true, touch: true

  validates :body, presence: true

  default_scope { order(updated_at: :asc) }
end
