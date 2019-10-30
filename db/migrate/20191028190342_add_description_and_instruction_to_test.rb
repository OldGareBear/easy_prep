class AddDescriptionAndInstructionToTest < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :description, :string
    add_column :tests, :instructions, :string
  end
end
