class AddOptionalRubricElementCriterionToRubricElement < ActiveRecord::Migration[5.2]
  def change
    add_reference :rubric_elements, :rubric_element_criterion, foreign_key: { to_table: :rubric_element_criterions, required: false }
  end
end
