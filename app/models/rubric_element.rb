class RubricElement < ApplicationRecord
  belongs_to :rubric
  belongs_to :skill, optional: true
end
