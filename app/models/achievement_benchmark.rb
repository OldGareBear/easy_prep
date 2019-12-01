class AchievementBenchmark < ApplicationRecord
  belongs_to :course

  def self.default_benchmark_data
    [
      {
        name: 'Exceeding Expectations',
        color: 'green',
        minimum_grade: '90',
      },
      {
        name: 'Meeting Expectations',
        color: 'yellow',
        minimum_grade: '80',
        maximum_grade: '89',
      },
      {
        name: 'Meeting Expectations',
        color: 'red',
        minimum_grade: '0',
        maximum_grade: '79',
      },
    ]
  end
end
