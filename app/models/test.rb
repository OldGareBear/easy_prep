class Test < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id
  has_many :test_assignments
  has_many :questions

  has_attached_file :document
end
