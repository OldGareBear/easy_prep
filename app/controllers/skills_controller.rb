class SkillsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @skill = Skill.find(params[:id])

    # New shit!!!!
    questions = Question.where(skill: @skill)
    test_assignments = TestAssignment.graded.where(course: @course).includes(:student)
    taqs = TestAssignmentQuestion.where(question: questions, test_assignment: test_assignments).includes(test_assignment: :student)
    correct_by_student = taqs.answered_correctly.group_by { |taq| taq.test_assignment.student }
    incorrect_by_student = taqs.answered_incorrectly.group_by { |taq| taq.test_assignment.student }

    byebug
    average_by_student = {}
    test_assignments.map(&:student).each do |student|
      num_correct = correct_by_student[student]&.count || 0
      num_incorrect = incorrect_by_student[student]&.count || 0
      average_by_student[student] = (num_correct.to_f / (num_correct + num_incorrect)) * 100
    end

    student_data = average_by_student.map { |student, score| { student: student, score: score } }

    @students_by_benchmark = student_data.group_by { |student| achievement_benchmark_for(student) }

    average_score = taqs.answered_correctly.count.to_f / taqs.count

    @score_data = TestAssignment
                    .connection
                    .execute("""SELECT total.name, total.created_at, (COALESCE(correct_answers, 0) / cast(total_questions as decimal) * 100) as score
                                FROM (
                                  SELECT tests.name, tests.created_at, COUNT(test_assignment_questions.id) AS total_questions
                                  FROM test_assignments
                                  JOIN tests ON tests.id = test_assignments.test_id
                                  JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                  JOIN questions ON questions.id = test_assignment_questions.question_id
                                  JOIN skills ON skills.id = questions.skill_id
                                  JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                  WHERE test_assignments.course_id = #{@course.id}
                                  AND test_assignments.graded_at IS NOT NULL
                                  AND skills.id = #{@skill.id}
                                  GROUP BY tests.name, tests.created_at
                                  ORDER BY tests.created_at ASC
                                ) total LEFT OUTER JOIN (
                                  SELECT tests.name, tests.created_at, COUNT(test_assignment_questions.id) AS correct_answers
                                  FROM test_assignments
                                  JOIN tests ON tests.id = test_assignments.test_id
                                  JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                  JOIN questions ON questions.id = test_assignment_questions.question_id
                                  JOIN skills ON skills.id = questions.skill_id
                                  JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                  WHERE test_assignments.course_id = #{@course.id}
                                  AND test_assignments.graded_at IS NOT NULL
                                  AND answer_options.correct = true
                                  AND skills.id = #{@skill.id}
                                  GROUP BY tests.name, tests.created_at
                                  ORDER BY tests.created_at ASC
                                ) correct ON correct.name  = total.name""")
                    .to_a.map { |hash| [hash['name'], hash['score']] }.to_h

    byebug
  end

  private

  def achievement_benchmark_for(student)
    AchievementBenchmark.where("minimum_grade <= #{student[:score]}").order('minimum_grade DESC').first
  end
end
