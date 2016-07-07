module Docurest
  class Client::Oauth < Docurest::Client
    AUTHENTICATION_HEADER = 'Authorization'

    def initialize(access_token, **options)
      super options
      @access_token = access_token
    end

    private

    def add_authentication_header(request)
      request[AUTHENTICATION_HEADER] = "bearer#{@access_token}" if @access_token
    end
  end
end
