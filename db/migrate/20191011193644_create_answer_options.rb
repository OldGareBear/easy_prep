class CreateAnswerOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_options do |t|
      t.references :question, foreign_key: true
      t.string :text
      t.string :correct
      t.string :boolean

      t.timestamps
    end
  end
end
