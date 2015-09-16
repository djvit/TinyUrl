# Factories definition
FactoryGirl.define do

  # User model factory definition
  factory :user do
    email      { Faker::Internet.email }
    password   { Faker::Internet.password(8) }
    name       { Faker::Name.name }
  end

  # Url model factory definition
  factory :url do
    user_id   { 1 } # Default users for tests
    path      { Faker::Internet.url }
    tiny_path { Faker::Lorem.characters(5) }
  end

end