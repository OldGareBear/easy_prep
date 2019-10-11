class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.primary_key :id
      t.string :name
      t.integer :creator_id

      t.timestamps

      add_reference :tests, :creator, foreign_key: { to_table: :users }
    end
  end
end
