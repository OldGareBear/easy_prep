class Question < ApplicationRecord
  belongs_to :question_type
  belongs_to :skill
  belongs_to :answer, class_name: 'AnswerOption', foreign_key: :answer_id, optional: true

  has_many :test_questions
  has_many :answer_options
end
