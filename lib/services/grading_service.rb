module Services
  class GradingService
    def initialize(test_assignment)
      @test_assignment = test_assignment
    end

    def multiple_choice_score
      correct_answers = test_assignment
                          .test_assignment_questions
                          .joins(:selected_answer)
                          .where(answer_options: { correct: true })
                          .count
      correct_answers * QuestionType.multiple_choice.max_points
    end

    private

    attr_reader :test_assignment
  end
end
