# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "factory_bot_rails"
include FactoryBot::Syntax::Methods
require "faker"

puts "🌱 Seeding data..."

# Clear existing records
BakeryMembership.delete_all
Bakery.delete_all
User.delete_all

# Create 3 bakery owners, each with a bakery
3.times do
  owner = create(:user)
  bakery = create(:bakery, name: "#{Faker::Name.first_name}'s Bakery")

  create(:bakery_membership, user: owner, bakery: bakery, role: "owner")

  puts "✅ Created #{bakery.name} (Owner: #{owner.email})"

  # Create 2 additional users as staff
  2.times do
    staff = create(:user)
    create(:bakery_membership, user: staff, bakery: bakery, role: "staff")
    puts "👨‍🍳 Added staff #{staff.email} to #{bakery.name}"
  end
end

puts "✅ Done seeding!"
