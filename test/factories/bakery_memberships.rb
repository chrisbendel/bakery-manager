FactoryBot.define do
  factory :bakery_membership do
    user
    bakery
    role { "owner" }
  end
end