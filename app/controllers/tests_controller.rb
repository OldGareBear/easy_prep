class TestsController < ApplicationController
  def new
    @course = Course.where(id: params[:course_id]).first
    @test = Test.new
  end

  def create
    @test = Test.new(new_test_params.merge(creator: current_user))
    @test.questions = create_questions(params[:question])
    @test.max_points = @test.questions.reduce(0) { |sum, question| question.question_type.max_points + sum }

    respond_to do |format|
      if @test.save
        if @course = Course.where(id: params[:course_id]).first
          format.html { redirect_to new_course_test_assignment_path(@course), notice: 'Test was successfully created.' }
        else
          # TODO: decide if I really want this to exist (probably not)
          format.html { redirect_to @test, notice: 'Test was successfully created.' }
        end
      else
        format.html { render :new }
      end
    end
  end

  def show
    @course = Course.find(params[:course_id])
    @test = Test.find(params[:id])

    @score_data = TestAssignment
                    .connection
                    .execute("""SELECT total.student_id, (COALESCE(correct_answers, 0) / cast(total_questions as decimal) * 100) as score
                                FROM (
                                  SELECT test_assignments.student_id, COUNT(test_assignment_questions.id) AS total_questions
                                  FROM test_assignments
                                  JOIN tests ON tests.id = test_assignments.test_id
                                  JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                  JOIN questions ON questions.id = test_assignment_questions.question_id
                                  JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                  WHERE test_assignments.course_id = #{@course.id}
                                  AND test_assignments.graded_at IS NOT NULL
                                  AND test_assignments.test_id = #{@test.id}
                                  GROUP BY test_assignments.student_id
                                ) total LEFT OUTER JOIN (
                                  SELECT test_assignments.student_id, COUNT(test_assignment_questions.id) AS correct_answers
                                  FROM test_assignments
                                  JOIN tests ON tests.id = test_assignments.test_id
                                  JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                  JOIN questions ON questions.id = test_assignment_questions.question_id
                                  JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                  WHERE test_assignments.course_id = #{@course.id}
                                  AND test_assignments.graded_at IS NOT NULL
                                  AND answer_options.correct = true
                                  AND test_assignments.test_id = #{@test.id}
                                  GROUP BY test_assignments.student_id
                                ) correct ON correct.student_id  = total.student_id""")
                    .to_a.map { |hash| [User.find(hash['student_id']).name, hash['score']] }.to_h

    skill_data = TestAssignment
                   .connection
                   .execute("""SELECT total.oid, total.skill_id, total_questions - correct_answers AS incorrect_answers, correct_answers
                               FROM (
                                 SELECT skills.oid, skills.id as skill_id, COUNT(test_assignment_questions.id) AS total_questions
                                 FROM test_assignments
                                 JOIN tests ON tests.id = test_assignments.test_id
                                 JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                 JOIN questions ON questions.id = test_assignment_questions.question_id
                                 JOIN skills ON skills.id = questions.skill_id
                                 JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                 WHERE test_assignments.course_id = #{@course.id}
                                 AND test_assignments.graded_at IS NOT NULL
                                 AND test_assignments.test_id = #{@test.id}
                                 GROUP BY skills.oid, skills.id
                               ) total LEFT OUTER JOIN (
                                 SELECT skills.oid, skills.id as skill_id, COUNT(test_assignment_questions.id) AS correct_answers
                                 FROM test_assignments
                                 JOIN tests ON tests.id = test_assignments.test_id
                                 JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                 JOIN questions ON questions.id = test_assignment_questions.question_id
                                 JOIN skills ON skills.id = questions.skill_id
                                 JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                 WHERE test_assignments.course_id = #{@course.id}
                                 AND test_assignments.graded_at IS NOT NULL
                                 AND answer_options.correct = true
                                 AND test_assignments.test_id = #{@test.id}
                                 GROUP BY skills.oid, skills.id
                              ) correct ON correct.oid  = total.oid""")

    @skill_data = skill_data.to_a.map do |skill|
      {
        oid: skill['oid'],
        skill_id: skill['skill_id'],
        incorrect_answers: skill['incorrect_answers'],
        correct_answers: skill['correct_answers']
      }
    end
  end

  private

  def create_questions(questions_params)
    questions = []
    questions_params.each do |_, question_params|
      question_type = find_question_type(question_params[:type])

      question = Question.create!(
        text: question_params[:description],
        question_type: question_type,
        skill: Skill.find_by(name: question_params[:skill])
      )

      question_params[:answer_option]&.each do |option_index, answer_option_text|
        ao = AnswerOption.create!(
          text: answer_option_text,
          correct: option_index == question_params[:correct_answer_options].first,
          question: question
        )
      end

      questions << question
    end

    questions
  end

  # TODO: refactor data model -- this is the worst thing about this project right now
  def find_question_type(basic_question_type_name)
    if ['short response', 'multiple choice'].include?(basic_question_type_name)
      QuestionType.find_by(name: basic_question_type_name)
    else
      case @test.grade.name
        when '3rd'
          QuestionType.find_by(name: 'third grade extended response')
        when %w(4th 5th)
          QuestionType.find_by(name: 'fourth and fifth grade extended response')
        else
          QuestionType.find_by(name: 'sixth to eighth grade extended response')
      end
    end
  end

  def new_test_params
    params.require(:test).permit(:name, :grade_id, :description, :instructions)
  end
end
