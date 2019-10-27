class AddOptionalSkillToRubricElement < ActiveRecord::Migration[5.2]
  def change
    add_reference :rubric_elements, :skill, foreign_key: { to_table: :skills, required: false }
  end
end
