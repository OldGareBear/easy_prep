class SkillsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @skill = Skill.find(params[:id])

    skill_analyzer = Services::TestAnalyzer.new(course: @course, skill: @skill)
    @students_by_benchmark = get_students_by_benchmark(skill_analyzer)
    @average_grade_by_test = get_average_grade_by_test(skill_analyzer)
  end

  private

  def get_students_by_benchmark(skill_analyzer)
    average_by_student = skill_analyzer.average_grade_by_student
    average_by_student_list = average_by_student.map { |student, score| { student: student, score: score } }
    average_by_student_list.group_by { |student| achievement_benchmark_for(student) }
  end

  def achievement_benchmark_for(student)
    AchievementBenchmark.where("minimum_grade <= #{student[:score]}").order('minimum_grade DESC').first
  end

  def get_average_grade_by_test(skill_analyzer)
    average_by_test = skill_analyzer.average_grade_by_test
    average_by_test.map { |test, score| [test.name, score.to_s] }.to_h
  end
end
