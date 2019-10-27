class CreateRubricElementCriterions < ActiveRecord::Migration[5.2]
  def change
    create_table :rubric_element_criterions do |t|
      t.text :name
      t.references :skill, foreign_key: true

      t.timestamps
    end

    remove_column :rubric_elements, :skill_id
  end
end
