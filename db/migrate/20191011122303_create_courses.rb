class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :grade

      t.timestamps
    end

    add_reference :courses, :teacher, foreign_key: { to_table: :users }
  end
end
