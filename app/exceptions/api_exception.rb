class ApiException < StandardError
  attr_accessor :code,
                :messages

  def initialize(error_constant, messages=nil)
    @error_constant = error_constant
    @code = @error_constant[:code]
    @messages = {
      "#{@error_constant[:key]}" => [ messages || @error_constant[:message] ]
    } 
  end

  def full_messages
    @messages.values.flatten
  end

  class << self
    def error_constants
      {
        INTERNAL_SERVER_ERROR: {
          code: 1100,
          message: t(1100),
          key: :internal_server_error
        },
        RECORD_NOT_FOUND: {
          code: 1200,
          message: t(1200),
          key: :record_not_found
        },
        USER_BANNED: {
          code: 1300,
          message: t(1300),
          key: :user_banned
        }
      }
    end

    private
    
    def t(code)
      I18n.t("api_response.code_#{code}")
    end
  end

  self.error_constants.each do | key, value |
    define_singleton_method(key.downcase) { value }
  end
end