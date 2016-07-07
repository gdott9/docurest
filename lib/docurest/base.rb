module Docurest
  class Base
    extend Docurest::Field

    def initialize(attributes = {})
      self.attributes = attributes
    end

    def persisted?
      !guid.nil?
    end

    private

    def attributes=(attributes)
      attributes.each do |key, value|
        send "#{key}=", value if respond_to?("#{key}=")
      end
    end
  end
end
