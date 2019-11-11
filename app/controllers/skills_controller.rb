class SkillsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @skill = Skill.find(params[:id])

    @score_data = TestAssignment
                    .connection
                    .execute("""SELECT total.name, total.created_at, (total_questions - correct_answers) / cast(correct_answers as decimal) as score
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
                                  AND answer_options.correct = TRUE
                                  AND skills.id = #{@skill.id}
                                  GROUP BY tests.name, tests.created_at
                                  ORDER BY tests.created_at ASC
                                ) correct ON correct.name  = total.name""")
                    .to_a.map do |skill|
                      { oid: skill['oid'],
                        skill_id: skill['skill_id'],
                        incorrect_answers: skill['incorrect_answers'],
                        correct_answers: skill['correct_answers']
                      }
    end
  end
end
