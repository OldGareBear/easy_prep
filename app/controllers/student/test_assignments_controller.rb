module Student
  class TestAssignmentsController < ApplicationController
    before_action :authenticate_user!

    def show
      @test_assignment = TestAssignment.where(id: params[:id]).first
    end

    def submit
      @test_assignment = TestAssignment.where(id: params[:test_assignment_id]).first

      respond_to do |format|
        if record_answers(@test_assignment, params[:questions])
          format.html { redirect_to student_dashboard_path, notice: 'Your answers have been recorded. Great work!' }
        else
          format.html { render :new }
        end
      end
    end

    private

    def record_answers(test_assignment, answers)
      test_assignment.test_assignment_questions.where(id: answers.keys).each do |question|
        question.answer_id = answers[question.id]
        question.save!
      end
      test_assignment.update_attribute(:submitted_at, Time.now)
    end
  end
end
