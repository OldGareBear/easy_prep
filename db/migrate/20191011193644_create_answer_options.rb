class CreateAnswerOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_options do |t|
      t.references :question, foreign_key: true
      t.string :text
      t.boolean :correct

      t.timestamps
    end
  end
end
