module Docurest
  class Client::Password < Docurest::Client
    AUTHENTICATION_HEADER = 'X-DocuSign-Authentication'

    def initialize(username, password, integrator_key, **options)
      super options
      @username = username
      @password = password
      @integrator_key = integrator_key
    end

    private

    def add_authentication_header(request)
      request[AUTHENTICATION_HEADER] = JSON.generate({
        "Username" => @username,
        "Password" => @password,
        "IntegratorKey" => @integrator_key,
      })
    end
  end
end
