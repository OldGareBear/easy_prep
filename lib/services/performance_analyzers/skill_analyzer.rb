module Services
  module PerformanceAnalyzers
    class SkillAnalyzer < BaseAnalyzer
      def average_grade
        average_by_skill = {}
        skills_tested.each do |skill|
          average_by_skill[skill] = average_for_skill(skill)
        end
        average_by_skill
      end

      private

      def skills_tested
        assigned_questions.map { |aq| aq.question.skill }.uniq
      end

      def correct_by_skill
        correct_answers.group_by { |aq| aq.question.skill }
      end

      def incorrect_by_skill
        incorrect_answers.group_by { |aq| aq.question.skill }
      end

      def num_correct_for_skill(skill)
        correct_by_skill[skill]&.count || 0
      end

      def num_incorrect_for_skill(skill)
        incorrect_by_skill[skill]&.count || 0
      end

      def average_for_skill(skill)
        num_correct = num_correct_for_skill(skill)
        num_incorrect = num_incorrect_for_skill(skill)
        percent_score(num_correct, num_incorrect)
      end
    end
  end
end