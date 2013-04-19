FactoryGirl.define do
  factory :image do
    url { Faker::Internet.url+'.jpg' }
    tumblr_blog
  end
end


