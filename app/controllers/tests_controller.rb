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
    @test = Test.find(params[:id])
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
