class RubricElementCriterion < ApplicationRecord
  belongs_to :skill
  has_many :rubric_elements
end
