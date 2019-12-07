task create_question_types: :environment do
  TEXT_OID_MAPPING = {
    'Valid inferences and/or claims from the text where required by the prompt' => 'MAKING VALID INFERENCES OR CLAIMS',
    'Evidence of analysis of the text where required by the prompt' => 'ANALYZING THE TEXT',
    'Relevant facts, definitions, concrete details, and/or other information from the text to develop response according to the requirements of the prompt' => 'USING RELEVANT DETAILS',
    'Sufficient number of facts, definitions, concrete details, and/or other information from the text as required by the prompt' => 'USING ENOUGH DETAILS',
    'Complete sentences where errors do not impact readability' => 'USING COMPLETE SENTENCES',
  }

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

  short_resp_parent_skill = Skill.find_or_create_by!(name: 'Short Response Features')

  two_point_elements.each do |element_text|
    skill = Skill.find_or_create_by!(
      name: element_text,
      oid: TEXT_OID_MAPPING[short_resp_writing_skill],
      parent: short_resp_parent_skill
    )
    RubricElement.find_or_create_by!(required_for_point_level: 2, rubric: short_response_rubric, text: element_text, skill: skill)
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
  short_response.save!




  # Extended response rubric malarkey
    # 3rd grade
  extended_resp_parent_skill = Skill.find_or_create_by!(name: 'Extended Response Criteria')

  third_grade_er_rubric =  Rubric.find_or_create_by!(name: 'third grade extended response rubric')
  QuestionType.find_or_create_by!(
    name: 'third grade extended response',
    rubric: third_grade_er_rubric
  )
      # CONTENT AND ANALYSIS

  content_and_analysis = Skill.find_or_create_by!(
    name: 'Convey ideas and information clearly and accurately in order to support analysis of topics or text',
    oid: 'CONTENT AND ANALYSIS',
    parent: extended_resp_parent_skill
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
        rubric: third_grade_er_rubric,
        text: element_text,
        skill: content_and_analysis
      )
    end
  end

      # COMMAND OF EVIDENCE
  command_of_evidence = Skill.find_or_create_by!(
    name: 'Present evidence from a provided text to support analysis and reflection',
    oid: 'COMMAND OF EVIDENCE',
    parent: extended_resp_parent_skill
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
        rubric: third_grade_er_rubric,
        text: element_text,
        skill: command_of_evidence
      )
    end
  end

      # COHERENCE, ORGANIZATION, AND STYLE
  coherence = Skill.find_or_create_by!(
    name: 'Logically organize complex ideas, concepts, and information using formal style and precise language',
    oid: 'COHERENCE, ORGANIZATION, AND STYLE',
    parent: extended_resp_parent_skill
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
        rubric: third_grade_er_rubric,
        text: element_text,
        skill: coherence
      )
    end
  end

      # CONTROL OF CONVENTIONS
  control = Skill.find_or_create_by!(
    name: 'Demonstrate command of the conventions of standard English grammar, usage, capitalization, punctuation, and spelling',
    oid: 'CONTROL OF CONVENTIONS',
    parent: extended_resp_parent_skill
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
        rubric: third_grade_er_rubric,
        text: element_text,
        skill: control
      )
    end
  end














      # 4rd grade
  fourth_grade_er_rubric =  Rubric.find_or_create_by!(name: 'fourth and fifth grade extended response rubric')
  QuestionType.find_or_create_by!(
    name: 'fourth and fifth grade extended response',
    rubric: fourth_grade_er_rubric
  )
  # CONTENT AND ANALYSIS

  points_to_c_and_a_elements = {
    4 => [
      'clearly introduce a topic in a manner that follows logically from the task and purpose',
      'demonstrate insightful comprehension and analysis of the text(s)',
    ],
    3 => [
      'clearly introduce a topic in a manner that follows from the task and purpose',
      'demonstrate grade-appropriate comprehension and analysis of the text(s)'
    ],
    2 => [
      'introduce a topic in a manner that follows generally from the task and purpose',
      'demonstrate a literal comprehension of the text(s)',
    ],
    1 => [
      'introduce a topic in a manner that does not logically follow from the task and purpose',
      'demonstrate little understanding of the text(s)',
    ],
    0 => [
      'demonstrate a lack of comprehension of the text(s) or task'
    ],
  }
  points_to_c_and_a_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: fourth_grade_er_rubric,
        text: element_text,
        skill: content_and_analysis
      )
    end
  end

  # COMMAND OF EVIDENCE

  points_to_command_of_evidence_elements = {
    4 => [
      'develop the topic with relevant, well-chosen facts, definitions, concrete details, quotations, or other information and examples from the text(s)',
      'sustain the use of varied, relevant evidence',
    ],
    3 => [
      'develop the topic with relevant facts, definitions, details, quota ons, or other information and examples from the text(s)',
      'sustain the use of relevant evidence, with some lack of variety',
    ],
    2 => [
      'partially develop the topic of the essay with the use of some textual evidence, some of which may be irrelevant',
      'use relevant evidence with inconsistency',
    ],
    1 => [
      'demonstrate an attempt to use evidence, but only develop ideas with minimal, occasional evidence which is generally invalid or irrelevant',
    ],
    0 => [
      'provide no evidence or provide evidence that is completely irrelevant'
    ],
  }
  points_to_command_of_evidence_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: fourth_grade_er_rubric,
        text: element_text,
        skill: command_of_evidence
      )
    end
  end

  # COHERENCE, ORGANIZATION, AND STYLE

  points_to_coherence_elements = {
    4 => [
      'exhibit clear, purposeful organization',
      'skillfully link ideas using grade-appropriate words and phrases',
      'use grade-appropriate, stylistically sophisticated language and domain-specific vocabulary',
      'provide a concluding statement that follows clearly from the topic and information presented',
    ],
    3 => [
      'exhibit clear organization',
      'link ideas using grade-appropriate words and phrases',
      'use grade-appropriate precise language and domain-specific vocabulary',
      'provide a concluding statement that follows from the topic and information presented',
    ],
    2 => [
      'exhibit some attempt at organization',
      'inconsistently link ideas using words and phrases',
      'inconsistently use appropriate language and domain-specific vocabulary',
      'provide a concluding statement that follows generally from the topic and information presented',
    ],
    1 => [
      'exhibit little attempt at organization, or attempts to organize are irrelevant to the task',
      'lack the use of linking words and phrases',
      'use language that is imprecise or inappropriate for the text(s) and task',
      'provide a concluding statement that is illogical or unrelated to the topic and information presented',
    ],
    0 => [
      'exhibit no evidence of organization',
      'exhibit no use of linking words and phrases',
      'use language that is predominantly incoherent or copied directly from the text(s)',
      'do not provide a concluding statement',
    ],
  }
  points_to_coherence_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: fourth_grade_er_rubric,
        text: element_text,
        skill: coherence
      )
    end
  end

  # CONTROL OF CONVENTIONS

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
        rubric: fourth_grade_er_rubric,
        text: element_text,
        skill: control
      )
    end
  end



















  # 6th grade
  sixth_grade_er_rubric =  Rubric.find_or_create_by!(name: 'sixth to eighth grade extended response rubric')
  QuestionType.find_or_create_by!(
    name: 'sixth to eighth grade extended response',
    rubric: sixth_grade_er_rubric
  )
  # CONTENT AND ANALYSIS

  points_to_c_and_a_elements = {
    4 => [
      'clearly introduce a topic in a manner that is compelling and follows logically from the task and purpose',
      'demonstrate insightful analysis of the text(s)',
    ],
    3 => [
      'clearly introduce a topic in a manner that follows from the task and purpose',
      'demonstrate grade-appropriate analysis of the text(s)'
    ],
    2 => [
      'introduce a topic in a manner that follows generally from the task and purpose',
      'demonstrate a literal comprehension of the text(s)',
    ],
    1 => [
      'introduce a topic in a manner that does not logically follow from the task and purpose',
      'demonstrate little understanding of the text(s)',
    ],
    0 => [
      'demonstrate a lack of comprehension of the text(s) or task'
    ],
  }
  points_to_c_and_a_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: sixth_grade_er_rubric,
        text: element_text,
        skill: content_and_analysis
      )
    end
  end

  # COMMAND OF EVIDENCE

  points_to_command_of_evidence_elements = {
    4 => [
      'develop the topic with relevant, well-chosen facts, de ni ons, concrete details, quota ons, or other information and examples from the text(s)',
      'sustain the use of varied, relevant evidence',
    ],
    3 => [
      'develop the topic with relevant facts, definitions, details, quota ons, or other information and examples from the text(s)',
      'sustain the use of relevant evidence, with some lack of variety',
    ],
    2 => [
      'par ally develop the topic of the essay with the use of some textual evidence, some of which may be irrelevant',
      'use relevant evidence with inconsistency',
    ],
    1 => [
      'demonstrate an attempt to use evidence, but only develop ideas with minimal, occasional evidence which is generally invalid or irrelevant',
    ],
    0 => [
      'provide no evidence or provide evidence that is completely irrelevant'
    ],
  }
  points_to_command_of_evidence_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: sixth_grade_er_rubric,
        text: element_text,
        skill: command_of_evidence
      )
    end
  end

  # COHERENCE, ORGANIZATION, AND STYLE

  points_to_coherence_elements = {
    4 => [
      'exhibit clear organization, with the skillful use of appropriate and varied transitions to create a uni ed whole and enhance meaning',
      'establish and maintain a formal style, using grade-appropriate, stylistically sophisticated language and domain-specific vocabulary with a notable sense of voice',
      'provide a concluding statement or section that is compelling and follows clearly from the topic and information presented',
    ],
    3 => [
      'exhibit clear organization, with the use of appropriate transitions to create a uni ed whole',
      'establish and maintain a formal style using precise language and domain-specific vocabulary',
      'provide a concluding statement or section that follows from the topic and information presented',
    ],
    2 => [
      'exhibit some attempt at organization, with inconsistent use of transitions',
      'establish but fail to maintain a formal style, with inconsistent use of language and domain-specific vocabulary',
      'provide a concluding statement or section that follows generally from the topic and information presented',
    ],
    1 => [
      'exhibit little attempt at organization, or attempts to organize are irrelevant to the task',
      'lack a formal style, using language that is imprecise or inappropriate for the text(s) and task',
      'provide a concluding statement or section that is illogical or unrelated to the topic and information presented',
    ],
    0 => [
      'exhibit no evidence of organization',
      'use language that is predominantly incoherent or copied directly from the text(s)',
      'do not provide a concluding statement or section',
    ],
  }
  points_to_coherence_elements.each do |points, element_texts|
    element_texts.each do |element_text|
      RubricElement.find_or_create_by!(
        required_for_point_level: points,
        rubric: sixth_grade_er_rubric,
        text: element_text,
        skill: coherence
      )
    end
  end

  # CONTROL OF CONVENTIONS

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
        rubric: sixth_grade_er_rubric,
        text: element_text,
        skill: control
      )
    end
  end
end
