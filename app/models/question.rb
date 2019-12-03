class Question < ApplicationRecord
  belongs_to :question_type
  belongs_to :skill, optional: true

  has_many :test_questions
  has_many :answer_options

  def multiple_choice?
    question_type.multiple_choice?
  end

  def short_response?
    question_type.short_response?
  end

  def extended_response?
    question_type.extended_response?
  end
end
