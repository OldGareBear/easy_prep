class RemoveGradeTextFromCourses < ActiveRecord::Migration[5.2]
  def change
    remove_column :courses, :grade
  end
end
