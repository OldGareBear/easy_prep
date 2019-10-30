class Test < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  belongs_to :grade
  has_many :test_assignments
  has_many :test_questions
  has_many :questions, through: :test_questions

  has_attached_file :document
end
