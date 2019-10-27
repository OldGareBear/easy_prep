class CreateGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :grades do |t|
      t.string :name

      t.timestamps
    end

    add_reference :courses, :grade, foreign_key: { to_table: :grades, required: true }
    add_reference :tests, :grade, foreign_key: { to_table: :grades, required: true }
  end
end
