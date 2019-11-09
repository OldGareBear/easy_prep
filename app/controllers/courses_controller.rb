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
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @course = Course.find(params[:id])
    @score_data = TestAssignment
                    .connection
                    .execute("""SELECT avg((test_assignments.score * 100) / cast(tests.max_points as decimal)), tests.name, tests.created_at
                                FROM test_assignments
                                JOIN tests ON tests.id = test_assignments.test_id
                                WHERE test_assignments.course_id = #{@course.id}
                                AND test_assignments.graded_at IS NOT NULL
                                AND test_assignments.score IS NOT NULL
                                GROUP BY tests.name, tests.created_at, tests.max_points
                                ORDER BY tests.created_at ASC""")
                    .to_a.map { |hash| [hash['name'], hash['avg']] }.to_h
    @skill_data = TestAssignment
                    .connection
                    .execute("""SELECT total.oid, total_questions - correct_answers AS incorrect_answers, correct_answers
                                FROM (
                                  SELECT skills.oid, COUNT(test_assignment_questions.id) AS total_questions
                                  FROM test_assignments
                                  JOIN tests ON tests.id = test_assignments.test_id
                                  JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                  JOIN questions ON questions.id = test_assignment_questions.question_id
                                  JOIN skills ON skills.id = questions.skill_id
                                  JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                  WHERE test_assignments.course_id = #{@course.id}
                                  AND test_assignments.graded_at IS NOT NULL
                                  GROUP BY skills.oid
                                ) total LEFT OUTER JOIN (
                                  SELECT skills.oid, COUNT(test_assignment_questions.id) AS correct_answers
                                  FROM test_assignments
                                  JOIN tests ON tests.id = test_assignments.test_id
                                  JOIN test_assignment_questions ON test_assignment_questions.test_assignment_id = test_assignments.id
                                  JOIN questions ON questions.id = test_assignment_questions.question_id
                                  JOIN skills ON skills.id = questions.skill_id
                                  JOIN answer_options ON answer_options.id = test_assignment_questions.answer_id
                                  WHERE test_assignments.course_id = #{@course.id}
                                  AND test_assignments.graded_at IS NOT NULL
                                  AND answer_options.correct = TRUE
                                  GROUP BY skills.oid
                                ) correct ON correct.oid  = total.oid""")
                    .to_a.map do |skill|
                      { skill['oid'] => {
                        incorrect_answers: skill['incorrect_answers'],
                        correct_answers: skill['correct_answers']
                      }}
                    end
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
    email_candidate_search = first_name.chars.first + last_name + '@' + fake_email_domain
    matches = User.where("email like ?", email_candidate_search).pluck(:email)
    highest_increment = matches.map { |match| match.match(/\d/).to_a.first.to_i }.max
    first_name.chars.first + last_name + increment(highest_increment, matches.count) + '@' + fake_email_domain
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
    params.require(:course).permit(:name, :grade_id)
  end

  def create_student!(first_name, last_name)
    User.create_student!(
      first_name: first_name,
      last_name: last_name,
      email: generate_fake_email(first_name, last_name),
      password: generate_fake_password(first_name, last_name)
    )
  end

  def fake_email_domain
    'easyprep.student'
  end
end
