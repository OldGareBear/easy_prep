class CreateRubricElements < ActiveRecord::Migration[5.2]
  def change
    create_table :rubric_elements do |t|
      t.text :text
      t.integer :required_for_point_level
      t.references :rubric, foreign_key: true

      t.timestamps
    end
  end
end
