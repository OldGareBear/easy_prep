task create_question_types: :environment do
  Grade.find_or_create_by(name: '3rd')
  Grade.find_or_create_by(name: '4th')
  Grade.find_or_create_by(name: '5th')
  Grade.find_or_create_by(name: '6th')
  Grade.find_or_create_by(name: '7th')
  Grade.find_or_create_by(name: '8th')

  QuestionType.find_or_create_by!(name: 'multiple choice')
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
    # 3rd grade
  third_grade_er_rubric =  Rubric.find_or_create_by!(name: 'third grade extended response rubric')
  QuestionType.find_or_create_by!(
    name: 'third grade extended response',
    rubric: third_grade_er_rubric
  )
      # CONTENT AND ANALYSIS

  content_and_analysis = Skill.find_or_create_by!(
    name: 'The extent to which the essay conveys ideas and information clearly and accurately in order to support analysis of topics or text',
    oid: 'CONTENT AND ANALYSIS'
  )

  points_to_c_and_a_elements = {
    4 => [
      'clearly introduce a topic in a manner that follows logically from the task and purpose',
      'demonstrate comprehension and analysis of the text',
    ],
    3 => [
      'clearly introduce a topic in a manner that follows from the task and purpose',
      'demonstrate grade-appropriate comprehension of the text'
    ],
    2 => [
      'introduce a topic in a manner that follows generally from the task and purpose',
      'demonstrate a confused comprehension of the text',
    ],
    1 => [
      'introduce a topic in a manner that does not logically follow from the task and purpose',
      'demonstrate little understanding of the text',
    ],
    0 => [
      'demonstrate a lack of comprehension of the text or task'
    ],
  }
  points_to_c_and_a_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: third_grade_extended_response_rubric,
        text: element_text,
        skill: content_and_analysis
      )
    end
  end

      # COMMAND OF EVIDENCE
  command_of_evidence = Skill.find_or_create_by!(
    name: 'The extent to which the essay presents evidence from the provided text to support analysis and refection',
    oid: 'COMMAND OF EVIDENCE'
  )

  points_to_command_of_evidence_elements = {
    4 => [
      'develop the topic with relevant, well-chosen facts, definitions, and details throughout the essay',
    ],
    3 => [
      'develop the topic with relevant facts, definitions, and details throughout the essay'
    ],
    2 => [
      'partially develop the topic of the essay with the use of some textual evidence, some of which may be irrelevant',
    ],
    1 => [
      'demonstrate an attempt to use evidence, but only develop ideas with minimal, occasional evidence which is generally invalid or irrelevant',
    ],
    0 => [
      'demonstrate a lack of comprehension of the text or task'
    ],
  }
  points_to_command_of_evidence_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: third_grade_extended_response_rubric,
        text: element_text,
        skill: command_of_evidence
      )
    end
  end

      # COHERENCE, ORGANIZATION, AND STYLE
  coherence = Skill.find_or_create_by!(
    name: 'The extent to which the essay logically organizes complex ideas, concepts, and information using formal style and precise language',
    oid: 'COHERENCE, ORGANIZATION, AND STYLE'
  )

  points_to_coherence_elements = {
    4 => [
      'clearly and consistently group related information together',
      'skillfully connect ideas within categories of information using linking words and phrases',
      'provide a concluding statement that follows clearly from the topic and information presented',
    ],
    3 => [
      'generally group related information together',
      'connect ideas within categories of information using linking words and phrases',
      'provide a concluding statement that follows from the topic and information presented',
    ],
    2 => [
      'exhibit some attempt to group related information together',
      'inconsistently connect ideas using some linking words and phrases',
      'provide a concluding statement that follows generally from the topic and information presented',
    ],
    1 => [
      'exhibit little attempt at organization',
      'lack the use of linking words and phrases',
      'provide a concluding statement that is illogical or unrelated to the topic and information presented',
    ],
    0 => [
      'exhibit no evidence of organization',
      'do not provide a concluding statement',
    ],
  }
  points_to_coherence_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: third_grade_extended_response_rubric,
        text: element_text,
        skill: coherence
      )
    end
  end

      # CONTROL OF CONVENTIONS
  control = Skill.find_or_create_by!(
    name: 'The extent to which the essay demonstrates command of the conventions of standard English grammar, usage, capitalization, punctuation, and spelling',
    oid: 'CONTROL OF CONVENTIONS'
  )

  points_to_control_elements = {
    4 => [
      'demonstrate grade-appropriate command of conventions, with few errors'
    ],
    3 => [
      'demonstrate grade-appropriate command of conventions, with occasional errors that do not hinder comprehension',
    ],
    2 => [
      'demonstrate emerging command of conventions, with some errors that may hinder comprehension',
    ],
    1 => [
      'demonstrate a lack of command of conventions, with frequent errors that hinder comprehension',
    ],
    0 => [
      'are minimal, making assessment of conventions unreliable',
    ],
  }
  points_to_control_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: third_grade_extended_response_rubric,
        text: element_text,
        skill: control
      )
    end
  end
end
