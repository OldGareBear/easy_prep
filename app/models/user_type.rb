class UserType < ApplicationRecord
  TEACHER_NAME = 'teacher'.freeze

  has_many :users

  def self.teacher
    find_by_name(TEACHER_NAME)
  end

  def teacher?
    name == TEACHER_NAME
  end
end
