FactoryBot.define do
  factory :bakery do
    name { "#{Faker::Dessert.variety} Bakery" }
    description { Faker::Food.description }
  end
end
