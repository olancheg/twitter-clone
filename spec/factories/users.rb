FactoryGirl.define do
  factory :user do
    email    { Faker::Internet.email }
    username { Faker::Internet.user_name }
    realname { Faker::Name.name }
    password { 'asdasd' }
    password_confirmation { password }
  end
end
