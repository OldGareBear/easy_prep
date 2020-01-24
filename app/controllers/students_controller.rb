class StudentsController < ApplicationController
  def show
    @course = Course.find(params[:course_id])
    @student = User.find(params[:id])

    @results_by_skill = Services::AnalyticsPresenter.get_results_by_skill(course: @course, student: @student)
    @score_by_test_name = Services::AnalyticsPresenter.get_score_by_test_name(course: @course, student: @student)
  end
end
