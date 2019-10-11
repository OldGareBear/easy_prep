class UserType < ApplicationRecord
  TEACHER = 'teacher'.freeze

  has_many :users

  def teacher?
    name == TEACHER
  end
end
