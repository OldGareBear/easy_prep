class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :user_type

  has_many :taught_courses, class_name: 'Course', foreign_key: :teacher_id

  has_many :students_courses, foreign_key: :student_id
  has_many :enrolled_courses, class_name: 'Course', through: :students_courses

  has_many :assigned_test_assignments, class_name: 'TestAssignment', foreign_key: :student_id

  def self.create_student!(attrs)
    create!(attrs.merge(user_type: UserType.student))
  end

  def self.create_teacher!(attrs)
    create!(attrs.merge(user_type: UserType.teacher))
  end

  def is_a_teacher?
    user_type&.teacher?
  end

  def is_a_student?
    user_type&.student?
  end

  def confirmation_required?
    user_type.teacher?
  end

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
