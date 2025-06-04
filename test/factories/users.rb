FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "Secret1*3*5*" }
    password_confirmation { "Secret1*3*5*" }
  end
end
