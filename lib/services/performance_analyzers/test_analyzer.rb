module Services
  module PerformanceAnalyzers
    class TestAnalyzer < BaseAnalyzer
      def average_grade
        average_by_test = {}
        tests_assigned.each do |test|
          average_by_test[test] = average_for_test(test)
        end
        average_by_test
      end

      private

      def tests_assigned
        test_assignments.map(&:test).uniq
      end

      def correct_by_test
        correct_answers.group_by { |aq| aq.test_assignment.test }
      end

      def incorrect_by_test
        incorrect_answers.group_by { |aq| aq.test_assignment.test }
      end

      def num_correct_for_test(test)
        correct_by_test[test]&.count || 0
      end

      def num_incorrect_for_test(test)
        incorrect_by_test[test]&.count || 0
      end

      def average_for_test(test)
        num_correct = num_correct_for_test(test)
        num_incorrect = num_incorrect_for_test(test)
        percent_score(num_correct, num_incorrect)
      end
    end
  end
end