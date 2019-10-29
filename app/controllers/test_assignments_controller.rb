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

  private

  def transactionally_save_assignments(params)
    TestAssignment.transaction do
      student_ids(params).each do |student_id|
        next if student_id == '0' # TODO: figure out why the form has all these 0 values
        @test_assignments << TestAssignment.create!(new_test_assignment_params.merge(student_id: student_id))
      end
    end
  end

  def new_test_assignment_params
    params.require(:test_assignment).permit(:test_id).merge(course_id: params[:course_id])
  end

  def student_ids(params)
    return @course.students.pluck(:id) if all_students?(params)
    params[:test_assignment][:students]
  end

  def all_students?(params)
    params[:test_assignment][:students].include?('all')
  end
end
