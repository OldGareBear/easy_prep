namespace :skills do
  desc 'Creates skills from CSV'
  task create_skills_from_csv: :environment do
    require 'csv'
    math_table = CSV.parse(File.read('lib/assets/nys-p-12-common-core-learning-standards-taxonomy-math.csv'), headers: true)
    ela_table = CSV.parse(File.read('lib/assets/nys-p-12-common-core-learning-standards-taxonomy-ela.csv'), headers: true)

    nys_common_core = Skill.create!(name: 'New York State P-12 Common Core Learning Standards')
    math = Skill.create!(name: 'Math', parent: nys_common_core)
    ela = Skill.create!(name: 'ELA', parent: nys_common_core)

    math_table.each do |row|
      learning_standard_oid = row[math_table[0].to_hash.keys.first] # For some reason 'Learning Standard' doesn't parse
      category_name = row['Category']
      sub_category_name = row['Sub-Category']
      state_standard_name = row['State Standard']

      category = Skill.find_or_create_by!(name: category_name, parent: math)
      sub_category = Skill.find_or_create_by!(name: sub_category_name, parent: category)
      Skill.find_or_create_by!(name: state_standard_name, oid: learning_standard_oid, parent: sub_category)
    end

    ela_table.each do |row|
      learning_standard_oid = row[ela_table[0].to_hash.keys.first] # For some reason 'Learning Standard' doesn't parse
      category_name = row['Category']
      sub_category_name = row['Sub-Category']
      state_standard_name = row['State Standard']

      category = Skill.find_or_create_by!(name: category_name, parent: ela)
      sub_category = Skill.find_or_create_by!(name: sub_category_name, parent: category)
      Skill.find_or_create_by!(name: state_standard_name, oid: learning_standard_oid, parent: sub_category)
    end
  end
end
