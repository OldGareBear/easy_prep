class Test < ApplicationRecord
  belongs_to :creator, class: 'User', foreign_key: :creator_id
end
