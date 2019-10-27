task create_question_types: :environment do
  third = Grade.find_or_create_by(name: '3rd')
  fourth = Grade.find_or_create_by(name: '4th')
  fifth = Grade.find_or_create_by(name: '5th')
  sixth = Grade.find_or_create_by(name: '6th')
  seventh = Grade.find_or_create_by(name: '7th')
  eighth = Grade.find_or_create_by(name: '8th')
end
