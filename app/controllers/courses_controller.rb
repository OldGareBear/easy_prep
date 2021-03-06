class CoursesController < ApplicationController
  DIRECT_COURSE_PARAMS = [:name, :grade_id]
  before_action :authenticate_user!

  def index
    @courses = current_user.taught_courses
  end

  def new
    @course = Course.new
  end

  def update
    @course = Course.find(params[:id])
    course_params.each do |key, val|
      @course.send("#{key}=", val) if DIRECT_COURSE_PARAMS.include?(key.to_sym)
    end

    missing_students = missing_students(params[:students])

    respond_to do |format|
      if @course.save && update_benchmarks(course_params[:achievement_benchmarks]) && transactionally_save_students(missing_students)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(course_params.merge(teacher: current_user))

    respond_to do |format|
      if @course.save && create_benchmarks(@course) && transactionally_save_students(params[:students])
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @course = Course.find(params[:id])


    @score_by_test_name = Services::AnalyticsPresenter.get_score_by_test_name(course: @course)

    @results_by_skill = Services::AnalyticsPresenter.get_results_by_skill(course: @course)
  end

  private

  def map_score_to_correct_incorrect_counts(skill, score, analyzer)
    relevant_question_count = analyzer.assigned_questions.where(questions: { skill: skill }).count
    {
        oid: skill.oid,
        skill_id: skill.id,
        incorrect_answers: (1 - (score / 100)) * relevant_question_count,
        correct_answers: (score / 100) * relevant_question_count,
    }
  end

  def missing_students(students_params)
    students_params.select do  |_, student_params|
      first_name, last_name = student_params[:first_name].capitalize, student_params[:last_name].capitalize
      existing_student = @course.students.where(first_name: first_name, last_name: last_name).first
      existing_student.nil?
    end
  end

  def transactionally_save_students(students_params)
    students =  []
    User.transaction do
      students_params.each do  |_, student_params|
        first_name, last_name = student_params[:first_name].downcase, student_params[:last_name].downcase
        students << create_student!(first_name, last_name)
      end
    end
    @course.students << students
  end

  def generate_fake_email(first_name, last_name)
    email_candidate_search = first_name.chars.first + last_name + '@' + fake_email_domain
    matches = User.where("email like ?", email_candidate_search).pluck(:email)
    highest_increment = matches.map { |match| match.match(/\d/).to_a.first.to_i }.max
    first_name.chars.first + last_name + increment(highest_increment,  matches.count) + '@' + fake_email_domain
  end

  def generate_fake_password(first_name, last_name)
    first_name.chars.first + last_name + '-password'
  end

  def increment(highest_increment, num_matches)
    return '' if num_matches == 0
    increment = highest_increment ? highest_increment + 1 : 2
    increment.to_s
  end

  def course_params
    params.require(:course).permit(:name, :grade_id, achievement_benchmarks: [:minimum_grade])
  end

  def create_student!(first_name, last_name)
    User.create_student!(
      first_name: first_name.capitalize,
      last_name: last_name.capitalize,
      email: generate_fake_email(first_name, last_name),
      password: generate_fake_password(first_name, last_name)
    )
  end

  def fake_email_domain
    'easyprep.student'
  end

  def create_benchmarks(course)
    AchievementBenchmark.default_benchmark_data.each do |hash|
      AchievementBenchmark.create!(hash.merge(course: course))
    end
  end

  def update_benchmarks(benchmark_data)
    benchmark_data.each do |id, hash|
      AchievementBenchmark.find(id).update(hash)
    end
  end
end
