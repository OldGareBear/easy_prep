class CreateSkillHierarchies < ActiveRecord::Migration[5.2]
  def change
    create_table :skill_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :skill_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "skill_anc_desc_idx"

    add_index :skill_hierarchies, [:descendant_id],
      name: "skill_desc_idx"
  end
end
