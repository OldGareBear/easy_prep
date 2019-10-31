class TestAssignment < ApplicationRecord
  belongs_to :test
  belongs_to :course
  belongs_to :student, class_name: 'User', foreign_key: :student_id
  has_many :test_assignment_questions
end
