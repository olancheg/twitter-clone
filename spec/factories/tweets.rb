FactoryGirl.define do
  factory :tweet do
    body { Faker::Lorem.sentence }
  end
end
