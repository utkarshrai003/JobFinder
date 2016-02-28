class User::User

    attr_accessor :result

	def initialize
		@result = User.none
	end

	def search(qwery = nil)
		return if qwery.nil?

		@result = Job.like(qwery)
		self
	end

end