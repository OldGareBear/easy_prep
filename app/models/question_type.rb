class QuestionType < ApplicationRecord
  belongs_to :rubric
  has_many :questions
end
