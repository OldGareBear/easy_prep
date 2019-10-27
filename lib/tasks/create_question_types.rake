task create_question_types: :environment do
  third = Grade.find_or_create_by(name: '3rd')
  fourth = Grade.find_or_create_by(name: '4th')
  fifth = Grade.find_or_create_by(name: '5th')
  sixth = Grade.find_or_create_by(name: '6th')
  seventh = Grade.find_or_create_by(name: '7th')
  eighth = Grade.find_or_create_by(name: '8th')

  multiple_choice = QuestionType.find_or_create_by!(name: 'multiple choice')
  short_response = QuestionType.find_or_create_by!(name: 'short response')

  # Short response rubric malarkey
  short_response_rubric = Rubric.find_or_create_by!(name: 'short response rubric')

  two_point_elements = [
    'Valid inferences and/or claims from the text where required by the prompt',
    'Evidence of analysis of the text where required by the prompt',
    'Relevant facts, definitions, concrete details, and/or other information from the text to develop response according to the requirements of the prompt',
    'Sufficient number of facts, definitions, concrete details, and/or other information from the text as required by the prompt',
    'Complete sentences where errors do not impact readability',
  ]

  two_point_elements.each do |element_text|
    RubricElement.find_or_create_by!(required_for_point_level: 2, rubric: short_response_rubric, text: element_text)
  end

  one_point_elements = [
    'A mostly literal recounting of events or details from the text as required by the prompt',
    'Some relevant facts, definitions, concrete details, and/or other information from the text to develop response according to the requirements of the prompt',
    'Incomplete sentences or bullets',
  ]

  one_point_elements.each do |element_text|
    RubricElement.find_or_create_by!(required_for_point_level: 1, rubric: short_response_rubric, text: element_text)
  end

  zero_point_elements = [
    'A response that does not address any of the requirements of the prompt or is totally inaccurate',
    'A response that is not written in English',
    'A response that is unintelligible or indecipherable',
  ]

  zero_point_elements.each do |element_text|
    RubricElement.find_or_create_by!(required_for_point_level: 0, rubric: short_response_rubric, text: element_text)
  end

  short_response.rubric = short_response_rubric

  # Extended response rubric malarkey

    # Create criteria, associating with skills
      # 3rd grade
  third_grade_extended_response_rubric =  Rubric.find_or_create_by!(name: 'third grade extended response rubric')

  content_and_analysis = RubricElementCriterion.find_or_create_by!(
    name: 'CONTENT AND ANALYSIS',
    description: 'the extent to which the essay conveys ideas and informa on clearly and accurately in order to support analysis of topics or text'
  )

  four_point_c_and_a_elements = [
    'clearly introduce a topic in a manner that follows logically from the task and purpose',
    'demonstrate comprehension and analysis of the text',
  ]
  four_point_c_and_a_elements.each do |element_text|
    RubricElement.find_or_create_by!(
      required_for_point_level: 4,
      rubric: third_grade_extended_response_rubric,
      text: element_text,
      rubric_element_criterion: content_and_analysis
    )
  end

    # Create rubric elements, one for each point level for each criterion for each grade set
end
