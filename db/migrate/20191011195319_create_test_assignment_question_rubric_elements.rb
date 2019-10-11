class CreateTestAssignmentQuestionRubricElements < ActiveRecord::Migration[5.2]
  def change
    create_table :test_assignment_question_rubric_elements do |t|
      t.references :test_assignment_question, foreign_key: true, index: { name: 'idx_test_assignment_q_rubric_elements_on_test_assignment_q_id' }
      t.references :rubric_element, foreign_key: true, index: { name: 'idx_test_assignment_q_rubric_elements_on_rubric_element_id' }
      t.boolean :present

      t.timestamps
    end
  end
end
