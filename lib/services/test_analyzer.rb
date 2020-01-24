module Services
  class TestAnalyzer
    def initialize(course:, test: nil, skill: nil, student: nil)
      @course = course
      @test = test
      @skill = skill
      @student = student
    end

    def average_grade_by_student
      average_by_student = {}
      students_assigned.each do |student|
        average_by_student[student] = average_for_student(student)
      end
      average_by_student
    end

    def average_grade_by_test
      average_by_test = {}
      tests_assigned.each do |test|
        average_by_test[test] = average_for_test(test)
      end
      average_by_test
    end

    def average_grade_by_skill
      average_by_skill = {}
      skills_tested.each do |skill|
        average_by_skill[skill] = average_for_skill(skill)
      end
      average_by_skill
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

    def correct_by_student
      correct_answers.group_by { |aq| aq.test_assignment.student }
    end

    def incorrect_by_student
      incorrect_answers.group_by { |aq| aq.test_assignment.student }
    end

    def correct_by_test
      correct_answers.group_by { |aq| aq.test_assignment.test }
    end

    def incorrect_by_test
      incorrect_answers.group_by { |aq| aq.test_assignment.test }
    end

    def correct_by_skill
      correct_answers.group_by { |aq| aq.question.skill }
    end

    def incorrect_by_skill
      incorrect_answers.group_by { |aq| aq.question.skill }
    end

    def students_assigned
      test_assignments.map(&:student).uniq
    end

    def tests_assigned
      test_assignments.map(&:test).uniq
    end

    def skills_tested
      assigned_questions.map { |aq| aq.question.skill }.uniq
    end

    def num_correct_for_student(student)
      correct_by_student[student]&.count || 0
    end

    def num_incorrect_for_student(student)
      incorrect_by_student[student]&.count || 0
    end

    def num_correct_for_test(test)
      correct_by_test[test]&.count || 0
    end

    def num_incorrect_for_test(test)
      incorrect_by_test[test]&.count || 0
    end

    def num_correct_for_skill(skill)
      correct_by_skill[skill]&.count || 0
    end

    def num_incorrect_for_skill(skill)
      incorrect_by_skill[skill]&.count || 0
    end

    def average_for_student(student)
      num_correct = num_correct_for_student(student)
      num_incorrect = num_incorrect_for_student(student)
      percent_score(num_correct, num_incorrect)
    end

    def average_for_test(test)
      num_correct = num_correct_for_test(test)
      num_incorrect = num_incorrect_for_test(test)
      percent_score(num_correct, num_incorrect)
    end

    def average_for_skill(skill)
      num_correct = num_correct_for_skill(skill)
      num_incorrect = num_incorrect_for_skill(skill)
      percent_score(num_correct, num_incorrect)
    end

    def percent_score(num_correct, num_incorrect)
      (num_correct.to_f / (num_correct + num_incorrect)) * 100
    end
  end
end