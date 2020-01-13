class ShortResponseQuestionTypeBuilder
  TEXT_OID_MAPPING = {
    'Valid inferences and/or claims from the text where required by the prompt' => 'MAKING VALID INFERENCES OR CLAIMS',
    'Evidence of analysis of the text where required by the prompt' => 'ANALYZING THE TEXT',
    'Relevant facts, definitions, concrete details, and/or other information from the text to develop response according to the requirements of the prompt' => 'USING RELEVANT DETAILS',
    'Sufficient number of facts, definitions, concrete details, and/or other information from the text as required by the prompt' => 'USING ENOUGH DETAILS',
    'Complete sentences where errors do not impact readability' => 'USING COMPLETE SENTENCES',
  }

  def build!
    possible_point_values.each do |value|
      find_or_create_skill_and_rubric_element_for_point_value(value)
    end

    short_response.rubric = short_response_rubric
    short_response.save!
  end

  def find_or_create_skill_and_rubric_element_for_point_value(value)
    elements_for_point_value(value).each do |element_text|
      skill = find_or_create_associated_skill(element_text, value)
      RubricElement.find_or_create_by!(required_for_point_level: score, rubric: short_response_rubric, text: element_text, skill: skill)
    end
  end

  def find_or_create_associated_skill(element_text, point_value)
    return nil unless top_point_value?(point_value)

    skill = Skill.find_or_create_by!(
      name: element_text,
      oid: TEXT_OID_MAPPING[element_text],
      parent: short_resp_parent_skill
    )
    RubricElement.find_or_create_by!(required_for_point_level: point_value, rubric: short_response_rubric, text: element_text, skill: skill)
  end

  def top_point_value?(score)
    score == possible_point_values.max
  end

  def possible_point_values
    elements_by_point_value.keys
  end

  def elements_by_point_value
    {
      2 => [
        'Valid inferences and/or claims from the text where required by the prompt',
        'Evidence of analysis of the text where required by the prompt',
        'Relevant facts, definitions, concrete details, and/or other information from the text to develop response according to the requirements of the prompt',
        'Sufficient number of facts, definitions, concrete details, and/or other information from the text as required by the prompt',
        'Complete sentences where errors do not impact readability',
      ],
      1 => [
        'A mostly literal recounting of events or details from the text as required by the prompt',
        'Some relevant facts, definitions, concrete details, and/or other information from the text to develop response according to the requirements of the prompt',
        'Incomplete sentences or bullets',
      ],
      0 => [
        'A response that does not address any of the requirements of the prompt or is totally inaccurate',
        'A response that is not written in English',
        'A response that is unintelligible or indecipherable',
      ],
    }
  end

  def elements_for_point_value(value)
    elements_by_point_value[value]
  end

  def short_resp_parent_skill
    @short_resp_parent_skill ||= Skill.find_or_create_by!(name: 'Short Response Features')
  end

  def short_response_rubric
    @short_response_rubric ||= find_or_create_rubric('short response rubric')
  end

  def short_response
    @short_response ||= find_or_create_question_type('short response')
  end

  def find_or_create_question_type(name)
    QuestionType.find_or_create_by!(name: name)
  end

  def find_or_create_rubric(name)
    Rubric.find_or_create_by!(name: name)
  end
end
