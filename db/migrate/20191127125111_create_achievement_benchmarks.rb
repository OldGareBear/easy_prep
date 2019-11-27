class CreateAchievementBenchmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :achievement_benchmarks do |t|
      t.string :name
      t.integer :minimum_grade
      t.string :color

      t.timestamps
    end

    add_reference :achievement_benchmarks, :course, foreign_key: { to_table: :courses, required: true }
  end
end
