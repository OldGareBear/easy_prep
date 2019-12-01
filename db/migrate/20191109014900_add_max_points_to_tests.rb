class AddMaxPointsToTests < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :max_points, :integer
  end
end
