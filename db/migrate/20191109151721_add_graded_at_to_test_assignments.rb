class AddGradedAtToTestAssignments < ActiveRecord::Migration[5.2]
  def change
    add_column :test_assignments, :graded_at, :datetime
  end
end
