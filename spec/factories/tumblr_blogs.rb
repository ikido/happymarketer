FactoryGirl.define do
  factory :tumblr_blog do
    name { Faker::Lorem.words(2).join('') }
  end
end


