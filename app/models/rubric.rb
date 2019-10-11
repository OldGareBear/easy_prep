class Rubric < ApplicationRecord
  has_many :rubric_elements
  has_many :question_types
end
