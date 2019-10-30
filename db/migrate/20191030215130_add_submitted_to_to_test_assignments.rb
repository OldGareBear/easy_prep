class AddSubmittedToToTestAssignments < ActiveRecord::Migration[5.2]
  def change
    add_column :test_assignments, :submitted_at, :datetime
  end
end
