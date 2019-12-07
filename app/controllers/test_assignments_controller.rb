require Rails.root.join('lib').join('services').join('test_assignment_factory.rb')

class TestAssignmentsController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    @test_assignment = TestAssignment.new
  end

  def create
    @course = Course.find(params[:course_id])
    @test_assignments = []

    respond_to do |format|
      if transactionally_save_assignments(params)
        format.html { redirect_to course_path(@course), notice: "Test was successfully assigned to #{@test_assignments.size} #{'student'.pluralize(@test_assignments.size)}." }
      else
        format.html { render :new }
      end
    end
  end

  def show
    @test_assignment = TestAssignment.find(params[:id])
    @course = Course.find(params[:course_id] || @test_assignment.course_id )
  end

  def grade
    @test_assignment = TestAssignment.where(id: params[:test_assignment_id]).first
    @test_assignment.graded_at = Time.now

    grade_short_response_questions(params)
    grade_extended_response_questions(params)

    # TODO (analyzing grades):
    # For all the TestAssignmentQuestionRubricElements assigned to a user that have a given skill, what percent
    # of them are present?

    respond_to do |format|
      if @test_assignment.save!
        format.html { redirect_to course_path(@test_assignment.course), notice: 'Test was successfully graded!' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def transactionally_save_assignments(params)
    TestAssignment.transaction do
      student_ids(params).each do |student_id|
        next if student_id == '0' # TODO: figure out why the form has all these 0 values
        test_assignment = Services::TestAssignmentFactory.create(
          test_id: params[:test_assignment][:test_id],
          course_id: params[:course_id],
          student_id: student_id
        )
        @test_assignments << test_assignment
      end
    end
  end

  def student_ids(params)
    return @course.students.pluck(:id) if all_students?(params)
    params[:test_assignment][:students]
  end

  def all_students?(params)
    params[:test_assignment][:students].include?('all')
  end

  def grade_short_response_questions(params)
    present_writing_elements = present_rubric_elements(params)

    TestAssignmentQuestionRubricElement.where(id: present_writing_elements).update_all(present: true)
    shorter_resp_questions = @test_assignment.test_assignment_questions.short_response.pluck(:id)
    shorter_resp_questions.each do |id|
      score = params[:test_assignment_questions][id.to_s].first.to_i
      @test_assignment.score += score
    end
  end

  def grade_extended_response_questions(params)
    # TODO: this is a mess, figure it out to make skill analytics work
    ext_resp_questions = @test_assignment.test_assignment_questions.extended_response.pluck(:id)
    ext_resp_questions.each do |id|
      score_total = 0.0
      score_components = 0
      params[:test_assignment_questions][id.to_s][:skills].each do |skill_id, score|
        score_total += score.to_i
        score_components += 1
        # RubricElement.where(
        #   skill_id: skill_id,
        #   required_for_point_level: score,
        # ).update_all(present: true)
      end

      score_for_question = (score_total / score_components).round
      @test_assignment.score += score_for_question
    end
  end

  def present_rubric_elements(params)
    present_elements = []
    params[:test_assignment_question_rubric_elements].each do |element|
      present_elements << element.first
    end

    present_elements
  end
end
