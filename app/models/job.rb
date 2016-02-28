class Job < ActiveRecord::Base
	belongs_to :recruiter
	belongs_to :company
	has_one :company , through: :recruiter
	has_many :job_applications
	has_many :applicants, through: :job_applications

    # validations on job creation

	validates :title , presence: {message: "title is not present"}
	validates :department , presence: {message: "department should be mentioned"}
	validates :location , presence: {message: "location field is empty"}
	validates :salary , presence: {message: "job with no salary..."} , numericality: {only_integer: true}
	validates :description , presence: {message: "give a proper desciption"}
	# should be numeric , +ve integer 
	validates :experience , presence: {message: "put 0 if no experience is needed"} , numericality: {only_integer: true}
    validates :terms_of_service, :acceptance => {:accept => true}

	scope :like, -> (search_text) { where("title like ? OR description like ? OR location like ?", "%#{search_text}%", "%#{search_text}%", "%#{search_text}%")}

    scope :active, -> { where("status = 'active'").order("created_at desc")}

    scope :title_like, -> (title) {where("title =  ?" , title)}

    scope :location_like, -> (location) {where("location =  ?" , location)}

    scope :experience_like, -> (experience) {where("experience = ?" , experience)}
end
