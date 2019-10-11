class CreateTestAssignmentQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :test_assignment_questions do |t|
      t.references :test_assignment, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end

    add_reference :test_assignment_questions, :answer, foreign_key: { to_table: :answer_options }
  end
end
