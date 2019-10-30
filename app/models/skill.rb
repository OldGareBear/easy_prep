class Skill < ApplicationRecord
  has_many :rubric_element_criterions
  has_many :questions
  has_closure_tree
end
