module Services
  class AnalyticsPresenter
    def self.get_score_by_test_name(course: nil, test: nil, skill: nil, student: nil)
      analyzer = Services::PerformanceAnalyzers::TestAnalyzer.new(course: course, test: test, skill: skill, student: student)
      score_by_test = analyzer.average_grade
      score_by_test.map { |test, score| [test.name, score.to_s] }.to_h
    end

    def self.get_score_by_student_name(course: nil, test: nil, skill: nil, student: nil)
      analyzer = Services::PerformanceAnalyzers::StudentAnalyzer.new(course: course, test: test, skill: skill, student: student)
      score_by_student = analyzer.average_grade
      score_by_student.map { |student, score| [student.name, score.to_s] }.to_h
    end

    def self.get_results_by_skill(course: nil, test: nil, skill: nil, student: nil)
      analyzer = Services::PerformanceAnalyzers::SkillAnalyzer.new(course: course, test: test, skill: skill, student: student)
      score_by_skill = analyzer.average_grade
      score_by_skill.map do |skill, score|
        map_score_to_correct_incorrect_counts(skill, score, analyzer)
      end
    end

    def self.map_score_to_correct_incorrect_counts(skill, score, analyzer)
      relevant_question_count = analyzer.assigned_questions.where(questions: { skill: skill }).count
      {
          oid: skill.oid,
          skill_id: skill.id,
          incorrect_answers: (1 - (score / 100)) * relevant_question_count,
          correct_answers: (score / 100) * relevant_question_count,
      }
    end

    private_class_method :map_score_to_correct_incorrect_counts
  end
end
