class UserType < ApplicationRecord
  TEACHER_NAME = 'teacher'.freeze
  STUDENT_NAME = 'student'.freeze

  has_many :users

  def self.teacher
    find_or_create_by(name: TEACHER_NAME)
  end

  def self.student
    find_or_create_by(name: STUDENT_NAME)
  end

  def teacher?
    name == TEACHER_NAME
  end

  def student?
    name == STUDENT_NAME
  end
end
