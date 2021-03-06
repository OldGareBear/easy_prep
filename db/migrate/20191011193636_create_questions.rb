class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :question_type, foreign_key: true
      t.references :skill, foreign_key: true
      t.text :text

      t.timestamps
    end
  end
end
