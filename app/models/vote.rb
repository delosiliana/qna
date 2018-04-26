class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :count, presence: true, inclusion: { in: [-1, 1] }
end
