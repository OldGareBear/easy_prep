class Question < ApplicationRecord
  belongs_to :question_type
  belongs_to :skill, optional: true

  has_many :test_questions
  has_many :answer_options
end
