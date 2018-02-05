class AddQuestionsToUser < ActiveRecord::Migration[5.1]
  def change
    add_belongs_to :questions, :user, foreign_key: true
  end
end
