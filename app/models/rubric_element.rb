class RubricElement < ApplicationRecord
  belongs_to :rubric
  has_one :rubric_element_criterion
end
