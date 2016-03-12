FactoryGirl.define do
  factory :applicant do
    email { FFaker::Internet.email }
    password "12345678"
    name { FFaker::Name.name }
    current_location "Lucknow"
    experience 1
  end
end
