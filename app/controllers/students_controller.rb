class StudentsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @student = User.find(params[:id])

    @results_by_skill = get_results_by_skill
    @score_by_test_name = get_score_by_test_name
  end

  private

  def get_results_by_skill
    student_analyzer = Services::TestAnalyzer.new(course: @course, student: @student, skill: @skill)
    score_by_skill = student_analyzer.average_grade_by_skill
    score_by_skill.map do |skill, score|
      map_score_to_correct_incorrect_counts(skill, score, student_analyzer)
    end
  end

  def get_score_by_test_name
    student_analyzer = Services::TestAnalyzer.new(course: @course, student: @student)
    score_by_test = student_analyzer.average_grade_by_test
    score_by_test.map { |test, score| [test.name, score.to_s] }.to_h
  end

  def map_score_to_correct_incorrect_counts(skill, score, student_analyzer)
    relevant_question_count = student_analyzer.assigned_questions.where(questions: { skill: skill }).count
    {
        oid: skill.oid,
        skill_id: skill.id,
        incorrect_answers: (1 - (score / 100)) * relevant_question_count,
        correct_answers: (score / 100) * relevant_question_count,
    }
  end
end
