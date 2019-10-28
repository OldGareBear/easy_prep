class QuestionType < ApplicationRecord
  belongs_to :rubric, optional: true
  has_many :questions


end
