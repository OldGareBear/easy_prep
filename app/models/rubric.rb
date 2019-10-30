class Rubric < ApplicationRecord
  has_many :rubric_elements
  has_many :question_types, class_name: 'QuestionType', foreign_key: :rubric_id
end
