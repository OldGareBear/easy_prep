class CreateTestAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :test_assignments do |t|
      t.references :test, foreign_key: true
      t.references :course, foreign_key: true
      t.datetime :due_at
      t.integer :score

      t.timestamps
    end

    add_reference :test_assignments, :student, foreign_key: { to_table: :users }
  end
end
