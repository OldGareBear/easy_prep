class CoursesController < ApplicationController
  def index
    @courses = current_user.taught_courses
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.new
  end

  def create
    byebug
    @course = Course.new(new_course_params.merge(teacher: current_user))

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @todo_list }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  private

  def new_course_params
    params.require(:course).permit(:name, :grade)
  end
end
