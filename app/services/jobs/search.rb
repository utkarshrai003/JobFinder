class Jobs::Search

    attr_accessor :result

	def initialize
		@result = Job.none
	end

	def search(qwery = nil)
		@result = Job.like(qwery).active
	end

	def with_title(title = nil)
		@result = Job.title_like(title).active
	end

	def with_title_location(title = nil , location = nil)
		@result = Job.title_like(title).location_like(location).active
	end

	def with_title_loc_exp(title = nil , location = nil , experience = nil)
		@result = Job.title_like(title).location_like(location).experience_like(experience).active
	end

end