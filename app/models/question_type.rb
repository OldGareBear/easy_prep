class QuestionType < ApplicationRecord
  MULTIPLE_CHOICE = 'multiple choice'
  SHORT_RESPONSE = 'short response'
  EXTENDED_RESPONSE = 'extended response'

  belongs_to :rubric, optional: true
  has_many :questions

  def self.multiple_choice
    find_by_name(MULTIPLE_CHOICE)
  end

  def self.short_response
    find_by_name(SHORT_RESPONSE)
  end

  def self.extended_response
    find_by_name(EXTENDED_RESPONSE)
  end

  def multiple_choice?
    name == MULTIPLE_CHOICE
  end

  def short_response?
    name == SHORT_RESPONSE
  end

  def extended_response?
    name == EXTENDED_RESPONSE
  end

  def max_points
    if multiple_choice?
      1
    elsif short_response?
      2
    else
      4
    end
  end
end
