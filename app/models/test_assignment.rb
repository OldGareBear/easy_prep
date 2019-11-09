class TestAssignment < ApplicationRecord
  belongs_to :test
  belongs_to :course
  belongs_to :student, class_name: 'User', foreign_key: :student_id
  has_many :test_assignment_questions

  scope :ungraded, -> { where(graded_at: nil) }
  scope :graded, -> { where.not(graded_at: nil) }

  def requires_manual_grading?
    test_assignment_questions
      .joins(question: :question_type)
      .where("question_types.name = '#{QuestionType::SHORT_RESPONSE}' OR question_types.name = '#{QuestionType::EXTENDED_RESPONSE}'")
      .exists?
  end
end
