class TestAssignment < ApplicationRecord
  belongs_to :test
  belongs_to :course
  belongs_to :student, class_name: 'User', foreign_key: :student_id
  has_many :test_assignment_questions

  scope :ungraded, -> do
    self.joins(test_assignment_questions: :test_assignment_question_rubric_elements)
      .where(test_assignment_questions: { test_assignment_question_rubric_elements: { present: nil } })
      .where.not(submitted_at: nil)
      .distinct
  end

  scope :graded, -> do
    self.joins(test_assignment_questions: :test_assignment_question_rubric_elements)
      .where.not(test_assignment_questions: { test_assignment_question_rubric_elements: { present: nil } })
      .where.not(submitted_at: nil)
      .distinct
    end
end
