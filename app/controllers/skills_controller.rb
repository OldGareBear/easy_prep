class SkillsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @skill = Skill.find(params[:id])

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

    student_data = TestAssignment
                     .connection
                     .execute("""SELECT total.student_id, total_questions, correct_answers
                                 FROM (
                                   SELECT test_assignments.student_id, COUNT(test_assignment_questions.id) AS total_questions
                                   FROM test_assignments
                                   JOIN tests ON tests.id = test_assignments.test_id
                                   JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                   JOIN questions ON questions.id = test_assignment_questions.question_id
                                   JOIN skills ON skills.id = questions.skill_id
                                   JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                   WHERE skills.id = #{@skill.id}
                                   AND test_assignments.graded_at IS NOT NULL
                                   GROUP BY test_assignments.student_id
                                 ) total LEFT OUTER JOIN (
                                   SELECT test_assignments.student_id, COUNT(test_assignment_questions.id) AS correct_answers
                                   FROM test_assignments
                                   JOIN tests ON tests.id = test_assignments.test_id
                                   JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                   JOIN questions ON questions.id = test_assignment_questions.question_id
                                   JOIN skills ON skills.id = questions.skill_id
                                   JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                   WHERE skills.id = #{@skill.id}
                                   AND test_assignments.graded_at IS NOT NULL
                                   AND answer_options.correct = true
                                   GROUP BY test_assignments.student_id
                                 ) correct ON correct.student_id  = total.student_id""")
                   .to_a.map do |student| {
        student_id: student['student_id'],
        total_questions: student['total_questions'] || 0,
        correct_answers: student['correct_answers'] || 0
      }
    end.map do |student|
      percent_score = (student[:correct_answers] / student[:total_questions].to_f) * 100
      { student: User.find(student[:student_id]), score: percent_score.to_i }
    end

    @students_by_benchmark = student_data.group_by { |student| achievement_benchmark_for(student) }
  end

  private

  def achievement_benchmark_for(student)
    AchievementBenchmark.where("minimum_grade <= #{student[:score]}").order('minimum_grade DESC').first
  end
end
