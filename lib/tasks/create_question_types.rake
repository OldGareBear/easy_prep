task create_question_types: :environment do
  third = Grade.find_or_create_by(name: '3rd')
  fourth = Grade.find_or_create_by(name: '4th')
  fifth = Grade.find_or_create_by(name: '5th')
  sixth = Grade.find_or_create_by(name: '6th')
  seventh = Grade.find_or_create_by(name: '7th')
  eighth = Grade.find_or_create_by(name: '8th')

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
  extended_response = QuestionType.find_or_create_by!(name: 'extended response')
      # Create criteria, associating with skills
        # CONTENT AND ANALYSIS
  third_grade_extended_response_rubric =  Rubric.find_or_create_by!(name: 'third grade extended response rubric')

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
      
    ],
    3 => [
      
    ],
    2 => [
      
    ],
    1 => [
      
    ],
    0 => [

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
end
