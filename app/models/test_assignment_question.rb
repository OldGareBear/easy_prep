class TestAssignmentQuestion < ApplicationRecord
  belongs_to :test_assignment
  belongs_to :question
  belongs_to :selected_answer, class_name: 'AnswerOption', foreign_key: 'answer_id', optional: true
  has_many :test_assignment_question_rubric_elements
end
