class CreateQuestionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :question_types do |t|
      t.string :name
      t.integer :max_points

      t.timestamps
    end

    add_reference :question_types, :rubric, foreign_key: { to_table: :rubrics, required: false }
  end
end
