module Student
  class DashboardController < ApplicationController
    BADGE_LEVEL = 0.9
    before_action :authenticate_user!

    def show
      @student = current_user
      skill_data = TestAssignment
                     .connection
                     .execute("""SELECT total.oid, total.skill_id, total_questions, correct_answers
                               FROM (
                                 SELECT skills.oid, skills.id as skill_id, COUNT(test_assignment_questions.id) AS total_questions
                                 FROM test_assignments
                                 JOIN tests ON tests.id = test_assignments.test_id
                                 JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                 JOIN questions ON questions.id = test_assignment_questions.question_id
                                 JOIN skills ON skills.id = questions.skill_id
                                 JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                 AND test_assignments.graded_at IS NOT NULL
                                 AND test_assignments.student_id = #{@student.id}
                                 GROUP BY skills.oid, skills.id
                               ) total LEFT OUTER JOIN (
                                 SELECT skills.oid, skills.id as skill_id, COUNT(test_assignment_questions.id) AS correct_answers
                                 FROM test_assignments
                                 JOIN tests ON tests.id = test_assignments.test_id
                                 JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                 JOIN questions ON questions.id = test_assignment_questions.question_id
                                 JOIN skills ON skills.id = questions.skill_id
                                 JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                 AND test_assignments.graded_at IS NOT NULL
                                 AND answer_options.correct = true
                                 AND test_assignments.student_id = #{@student.id}
                                 GROUP BY skills.oid, skills.id
                               ) correct ON correct.oid  = total.oid""")
                     .to_a.map do |skill| {
                        oid: skill['oid'],
                        skill_id: skill['skill_id'],
                        total_questions: skill['total_questions'] || 0,
                        correct_answers: skill['correct_answers'] || 0
                      }
      end

      @badges = skill_data.map do |skill|
        percent_score = (skill[:correct_answers] / skill[:total_questions].to_f) * 100
        { skill: Skill.find(skill[:skill_id]), score: percent_score }
      end.select do |skill|
        skill[:score] >= BADGE_LEVEL
      end
    end
  end
end
