# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Company.create(name: 'CodeBrahma Technologies', code: 'codebrahma')
Company.create(name: 'Amadeus Labs', code: 'amadeus')

Department.create(name: 'finance', company_id: 1)
Department.create(name: 'production', company_id: 1)
Department.create(name: 'hr' , company_id: 2)
Department.create(name: 'marketting' , company_id: 2)

Role.create(name: 'admin')
Role.create(name: 'recruiter')

Job.create(title: 'developer' , department: 'production' , location: 'bangalore' , salary: 300000 , description: 'deep knowledge in wen programming' , experience: 1 , company_id: 1 , recruiter_id: 1)
Job.create(title: 'financial head' , department: 'finance' , location: 'bangalore' , salary: 300000 , description: 'must have good managerial skills' , experience: 1 , company_id: 1 , recruiter_id: 2)

JobApplication.create(applicant_id: 1 , job_id: 1 , company_id: 1)
JobApplication.create(applicant_id: 2 , job_id: 1 , company_id: 1)