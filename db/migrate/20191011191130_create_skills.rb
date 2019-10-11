class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.string :name

      t.timestamps
    end

    add_reference :skills, :parent, foreign_key: { to_table: :skills, required: false }
  end
end
