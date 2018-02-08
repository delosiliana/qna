class AddAnswersToUser < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :answers, :user, foreign_key: true
  end
end
