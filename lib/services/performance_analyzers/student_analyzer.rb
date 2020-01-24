module Services
  module PerformanceAnalyzers
    class StudentAnalyzer < BaseAnalyzer
      def average_grade
        average_by_student = {}
        students_assigned.each do |student|
          average_by_student[student] = average_for_student(student)
        end
        average_by_student
      end

      private

      def students_assigned
        test_assignments.map(&:student).uniq
      end

      def correct_by_student
        correct_answers.group_by { |aq| aq.test_assignment.student }
      end

      def incorrect_by_student
        incorrect_answers.group_by { |aq| aq.test_assignment.student }
      end

      def num_correct_for_student(student)
        correct_by_student[student]&.count || 0
      end

      def num_incorrect_for_student(student)
        incorrect_by_student[student]&.count || 0
      end

      def average_for_student(student)
        num_correct = num_correct_for_student(student)
        num_incorrect = num_incorrect_for_student(student)
        percent_score(num_correct, num_incorrect)
      end
    end
  end
end