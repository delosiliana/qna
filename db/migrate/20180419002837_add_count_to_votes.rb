class AddCountToVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :count, :integer
  end
end
