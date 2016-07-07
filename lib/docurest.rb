require "docurest/version"

require "docurest/field"

require "docurest/client"
require "docurest/client/oauth"
require "docurest/client/password"

require "docurest/base"

require "docurest/envelope"
require "docurest/envelope/document"
require "docurest/envelope/recipient"
require "docurest/envelope/recipient/tab"

require "docurest/login"

module Docurest
  class << self
    attr_accessor :client

    def with_client(other_client)
      old_client = @client
      @client = other_client

      yield if block_given?
    ensure
      @client = old_client
    end
  end
end
