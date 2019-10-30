class Grade < ApplicationRecord
  has_many :tests
  has_many :course
end
