class BakeryMembership < ApplicationRecord
  belongs_to :user
  belongs_to :bakery

  enum :role, {owner: 0, staff: 1}
end
