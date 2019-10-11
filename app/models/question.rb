class Question < ApplicationRecord
  belongs_to :question_type
  belongs_to :skill
  has_one :answer, class: 'AnswerOption', foreign_key: :answer_id

  has_many :test_questions
  has_many :answer_options
end
