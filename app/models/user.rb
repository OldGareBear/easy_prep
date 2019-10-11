class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :user_type

  has_many :taught_courses, class_name: 'Course', foreign_key: :teacher_id

  has_many :students_courses, foreign_key: :student_id
  has_many :enrolled_courses, class_name: 'Course', through: :students_courses
end
