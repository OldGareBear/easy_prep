class TestAssignmentsController < ApplicationController
  def new
    @course = Course.find(params[:course_id])
    @test_assignment = TestAssignment.new
  end

  def create
    @test_assignment = TestAssignment.new(new_test_assignment_params)

    respond_to do |format|
      if @test_assignment.save && transactionally_save_students
        format.html { redirect_to @test_assignment, notice: 'Test was successfully assigned.' }
        format.json { render :show, status: :created, location: @test_assignment }
      else
        format.html { render :new }
        format.json { render json: @test_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def transactionally_save_students
  end

  def new_test_assignment_params
  end
end
