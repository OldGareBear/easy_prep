class CreateStudentsCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :students_courses do |t|
      t.references :course, foreign_key: true

      t.timestamps
    end

    add_reference :students_courses, :student, foreign_key: { to_table: :users }
  end
end
