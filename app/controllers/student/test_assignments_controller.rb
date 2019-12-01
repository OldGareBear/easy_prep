require Rails.root.join('lib').join('services').join('grading_service.rb')

module Student
  class TestAssignmentsController < ApplicationController
    before_action :authenticate_user!

    def show
      @test_assignment = TestAssignment.where(id: params[:id]).first
      if @test_assignment.submitted_at
        render :show_locked
      else
        render :show
      end
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
      test_assignment.test_assignment_questions.where(id: answers&.keys).each do |question|
        question.answer_id = answers[question.id.to_s].first
        question.save!
      end

      grader = Services::GradingService.new(test_assignment)
      graded_at = test_assignment.requires_manual_grading? ? nil : Time.now
      test_assignment.update_attributes(
        submitted_at: Time.now,
        score: grader.multiple_choice_score,
        graded_at: graded_at
      )
    end
  end
end
