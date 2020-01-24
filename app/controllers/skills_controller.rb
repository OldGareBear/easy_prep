class SkillsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @skill = Skill.find(params[:id])

    @students_by_benchmark = get_students_by_benchmark
    @score_by_test_name = Services::AnalyticsPresenter.get_score_by_test_name(course: @course, skill: @skill)
  end

  private

  def get_students_by_benchmark
    analyzer = Services::PerformanceAnalyzers::StudentAnalyzer.new(course: @course, skill: @skill)
    average_by_student = analyzer.average_grade
    average_by_student_list = average_by_student.map { |student, score| { student: student, score: score } }
    average_by_student_list.group_by { |student| achievement_benchmark_for(student) }
  end

  def achievement_benchmark_for(student)
    AchievementBenchmark.where("minimum_grade <= #{student[:score]}").order('minimum_grade DESC').first
  end
end
