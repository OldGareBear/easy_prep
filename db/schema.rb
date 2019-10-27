# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_27_185613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answer_options", force: :cascade do |t|
    t.bigint "question_id"
    t.string "text"
    t.string "correct"
    t.string "boolean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answer_options_on_question_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "teacher_id"
    t.bigint "grade_id"
    t.index ["grade_id"], name: "index_courses_on_grade_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "grades", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_types", force: :cascade do |t|
    t.string "name"
    t.integer "max_points"
    t.bigint "rubric_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubric_id"], name: "index_question_types_on_rubric_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "question_type_id"
    t.bigint "skill_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_type_id"], name: "index_questions_on_question_type_id"
    t.index ["skill_id"], name: "index_questions_on_skill_id"
  end

  create_table "rubric_element_criterions", force: :cascade do |t|
    t.text "name"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["skill_id"], name: "index_rubric_element_criterions_on_skill_id"
  end

  create_table "rubric_elements", force: :cascade do |t|
    t.text "text"
    t.integer "required_for_point_level"
    t.bigint "rubric_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "rubric_element_criterion_id"
    t.index ["rubric_element_criterion_id"], name: "index_rubric_elements_on_rubric_element_criterion_id"
    t.index ["rubric_id"], name: "index_rubric_elements_on_rubric_id"
  end

  create_table "rubrics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skill_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "skill_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "skill_desc_idx"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_id"
    t.string "oid"
    t.index ["parent_id"], name: "index_skills_on_parent_id"
  end

  create_table "students_courses", force: :cascade do |t|
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_id"
    t.index ["course_id"], name: "index_students_courses_on_course_id"
    t.index ["student_id"], name: "index_students_courses_on_student_id"
  end

  create_table "test_assignment_question_rubric_elements", force: :cascade do |t|
    t.bigint "test_assignment_question_id"
    t.bigint "rubric_element_id"
    t.boolean "present"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rubric_element_id"], name: "idx_test_assignment_q_rubric_elements_on_rubric_element_id"
    t.index ["test_assignment_question_id"], name: "idx_test_assignment_q_rubric_elements_on_test_assignment_q_id"
  end

  create_table "test_assignment_questions", force: :cascade do |t|
    t.bigint "test_assignment_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "answer_id"
    t.index ["answer_id"], name: "index_test_assignment_questions_on_answer_id"
    t.index ["question_id"], name: "index_test_assignment_questions_on_question_id"
    t.index ["test_assignment_id"], name: "index_test_assignment_questions_on_test_assignment_id"
  end

  create_table "test_assignments", force: :cascade do |t|
    t.bigint "test_id"
    t.bigint "course_id"
    t.datetime "due_at"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "student_id"
    t.index ["course_id"], name: "index_test_assignments_on_course_id"
    t.index ["student_id"], name: "index_test_assignments_on_student_id"
    t.index ["test_id"], name: "index_test_assignments_on_test_id"
  end

  create_table "test_questions", force: :cascade do |t|
    t.bigint "test_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_test_questions_on_question_id"
    t.index ["test_id"], name: "index_test_questions_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "creator_id"
    t.string "document_file_name"
    t.string "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
    t.bigint "grade_id"
    t.index ["creator_id"], name: "index_tests_on_creator_id"
    t.index ["grade_id"], name: "index_tests_on_grade_id"
  end

  create_table "user_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.bigint "user_type_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_type_id"], name: "index_users_on_user_type_id"
  end

  add_foreign_key "answer_options", "questions"
  add_foreign_key "courses", "grades"
  add_foreign_key "courses", "users", column: "teacher_id"
  add_foreign_key "question_types", "rubrics"
  add_foreign_key "questions", "question_types"
  add_foreign_key "questions", "skills"
  add_foreign_key "rubric_element_criterions", "skills"
  add_foreign_key "rubric_elements", "rubric_element_criterions"
  add_foreign_key "rubric_elements", "rubrics"
  add_foreign_key "skills", "skills", column: "parent_id"
  add_foreign_key "students_courses", "courses"
  add_foreign_key "students_courses", "users", column: "student_id"
  add_foreign_key "test_assignment_question_rubric_elements", "rubric_elements"
  add_foreign_key "test_assignment_question_rubric_elements", "test_assignment_questions"
  add_foreign_key "test_assignment_questions", "answer_options", column: "answer_id"
  add_foreign_key "test_assignment_questions", "questions"
  add_foreign_key "test_assignment_questions", "test_assignments"
  add_foreign_key "test_assignments", "courses"
  add_foreign_key "test_assignments", "tests"
  add_foreign_key "test_assignments", "users", column: "student_id"
  add_foreign_key "test_questions", "questions"
  add_foreign_key "test_questions", "tests"
  add_foreign_key "tests", "grades"
  add_foreign_key "tests", "users", column: "creator_id"
end
