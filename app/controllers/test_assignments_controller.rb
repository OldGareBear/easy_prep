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
    @course = Course.find(params[:course_id])
    @test_assignment = TestAssignment.find(params[:id])
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
end
