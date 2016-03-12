FactoryGirl.define do
  factory :job do
    title "software developer"
    department "production"
    location "Lucknow"
    salary 5000000
    description "good rogramming skills"
    experience 1
    status "pending"
    company_id 1
    recruiter_id 1
  end
end
