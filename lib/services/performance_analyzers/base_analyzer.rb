module Services
  module PerformanceAnalyzers
    class BaseAnalyzer
      def initialize(course:, test: nil, skill: nil, student: nil)
        @course = course
        @test = test
        @skill = skill
        @student = student
      end

      def assigned_questions
        TestAssignmentQuestion
            .where(question: questions, test_assignment: test_assignments)
            .includes(test_assignment: :student, question: :skill)
      end

      private

      def questions
        questions = Question.all

        # Filter skill if requested
        if @skill
          questions = questions.where(skill: @skill)
        end
        questions
      end

      def test_assignments
        test_assignments = TestAssignment.graded.where(course: @course).includes(:student, :test)

        # Filter test if requested
        if @test
          test_assignments = test_assignments.where(test: @test)
        end

        # Filter student if requested
        if @student
          test_assignments = test_assignments.where(student: @student)
        end

        test_assignments
      end

      def correct_answers
        assigned_questions.answered_correctly
      end

      def incorrect_answers
        assigned_questions.answered_incorrectly
      end

      def percent_score(num_correct, num_incorrect)
        (num_correct.to_f / (num_correct + num_incorrect)) * 100
      end
    end
  end
end