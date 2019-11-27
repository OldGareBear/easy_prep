class Course < ApplicationRecord
  belongs_to :teacher, class_name: 'User', foreign_key: :teacher_id
  belongs_to :grade
  has_many :students_courses, dependent: :destroy
  has_many :students, through: :students_courses
  has_many :test_assignments
  has_many :test_assignment_questions, through: :test_assignments
  has_many :tests, through: :test_assignments
  has_many :achievement_benchmarks
end
