class AddDescriptionToRubricElementCriterion < ActiveRecord::Migration[5.2]
  def change
    add_column :rubric_element_criterions, :description, :string
  end
end
