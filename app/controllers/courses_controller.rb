class CoursesController < ApplicationController
  def index
    @courses = current_user.taught_courses
  end

  def new
  end

  def create
  end

  def new_course_params
    params.require(:course).permit(:)
  end
end
