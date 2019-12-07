class TestAssignmentQuestion < ApplicationRecord
  belongs_to :test_assignment
  belongs_to :question
  belongs_to :selected_answer, class_name: 'AnswerOption', foreign_key: 'answer_id', optional: true
  has_many :test_assignment_question_rubric_elements

  scope :answered_correctly, -> do
    self.joins(:selected_answer).where(answer_options: { correct: true })
  end

  scope :answered_incorrectly, -> do
    self.joins(:selected_answer).where(answer_options: { correct: false })
  end

  scope :short_response, -> { self.joins(question: :question_type).where(question_types: { name: 'short response' }) }
  scope :extended_response, -> { self.joins(question: :question_type).where("question_types.name like '%extended response'") }
  scope :multiple_choice, -> { self.joins(question: :question_type).where(question_types: { name: 'multiple choice' }) }
end
