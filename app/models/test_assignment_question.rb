class TestAssignmentQuestion < ApplicationRecord
  belongs_to :test_assignment
  belongs_to :question
  belongs_to :selected_answer, class_name: 'AnswerOption', foreign_key: 'answer_id', optional: true
end
