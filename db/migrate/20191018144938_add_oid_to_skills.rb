class AddOidToSkills < ActiveRecord::Migration[5.2]
  def change
    add_column :skills, :oid, :string
  end
end
