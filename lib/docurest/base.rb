module Docurest
  class Base
    extend Docurest::Field

    def self.hash_by_type(array)
      array.each_with_object(Hash.new { |h,k| h[k] = [] }) do |value, hash|
        hash[value.type.to_sym] << value.to_h
      end
    end

    def initialize(attributes = {})
      self.attributes = attributes
    end

    def persisted?
      @persisted || (respond_to?(:guid) && guid)
    end

    private

    def attributes=(attributes)
      return unless attributes
      attributes.each do |key, value|
        send "#{key}=", value if respond_to?("#{key}=")
      end
    end
  end
end
