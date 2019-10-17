class CoursesController < ApplicationController
  before_action :authenticate_user!

  def index
    @courses = current_user.taught_courses
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(new_course_params.merge(teacher: current_user))

    respond_to do |format|
      if @course.save && transactionally_save_students
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @todo_list }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  def transactionally_save_students
    students =  []
    User.transaction do
      params[:students].each do  |_, student_params|
        first_name, last_name = student_params[:first_name].downcase, student_params[:last_name].downcase
        students << create_student!(first_name, last_name)
      end
    end
    @course.students << students
  end

  def generate_fake_email(first_name, last_name)
    email_candidate_search = first_name.chars.first + last_name + '%@easy_prep.student'
    matches = User.where("email like ?", email_candidate_search).pluck(:email)
    highest_increment = matches.map { |match| match.match(/\d/).to_a.first.to_i }.max
    first_name.chars.first + last_name + increment(highest_increment, matches.count)  + '@easy_prep.student'
  end

  def generate_fake_password(first_name, last_name)
    first_name.chars.first + last_name + '-password'
  end

  def increment(highest_increment, num_matches)
    return '' if num_matches == 0
    increment = highest_increment ? highest_increment + 1 : 2
    increment.to_s
  end

  def new_course_params
    params.require(:course).permit(:name, :grade)
  end

  def create_student!(first_name, last_name)
    User.create_student!(
      first_name: first_name,
      last_name: last_name,
      email: generate_fake_email(first_name, last_name),
      password: generate_fake_password(first_name, last_name)
    )
  end
end
