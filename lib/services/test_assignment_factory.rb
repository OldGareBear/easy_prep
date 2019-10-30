module Services
  class TestAssignmentFactory
    def self.create(test_id:, course_id:, student_id:)
      test_assignment = TestAssignment.create!(test_id: test_id, course_id: course_id, student_id: student_id)
      test_assignment.test.questions.each do |question|
        test_assignment_question = TestAssignmentQuestion.create!(test_assignment: test_assignment, question: question)
        question.question_type&.rubric&.rubric_elements&.each do |rubric_element|
          TestAssignmentQuestionRubricElement.create!(
            test_assignment_question: test_assignment_question,
            rubric_element: rubric_element
          )
        end
      end

      test_assignment
    end
  end
end
