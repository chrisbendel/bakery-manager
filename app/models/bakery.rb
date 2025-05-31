class Bakery < ApplicationRecord
  has_many :bakery_memberships
  has_many :users, through: :bakery_memberships
end
