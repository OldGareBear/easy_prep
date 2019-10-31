class QuestionType < ApplicationRecord
  MULTIPLE_CHOICE = 'multiple choice'
  SHORT_RESPONSE = 'short response'

  belongs_to :rubric, optional: true
  has_many :questions

  def multiple_choice?
    name == MULTIPLE_CHOICE
  end

  def short_response?
    name == SHORT_RESPONSE
  end

  def extended_response?
    !(multiple_choice? || short_response?)
  end
end
