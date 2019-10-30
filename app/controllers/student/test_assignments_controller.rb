module Student
  class TestAssignmentsController < ApplicationController
    before_action :authenticate_user!

    def show
      @test_assignments = TestAssignment.where(id: params[:id])
    end
  end
end
