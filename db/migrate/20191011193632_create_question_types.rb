class CreateQuestionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :question_types do |t|
      t.string :name
      t.integer :max_points
      t.references :rubric, foreign_key: true

      t.timestamps
    end
  end
end
