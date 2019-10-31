module Student
  class TestAssignmentsController < ApplicationController
    before_action :authenticate_user!

    def show
      @test_assignment = TestAssignment.where(id: params[:id]).first
    end
  end
end
