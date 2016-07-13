require "docurest/field/base"
require "docurest/field/boolean"
require "docurest/field/date_time"
require "docurest/field/integer"
require "docurest/field/float"

module Docurest
  module Field
    CONVERSION = {
      boolean: Docurest::Field::Boolean,
      integer: Docurest::Field::Integer,
      float: Docurest::Field::Float,
      date_time: Docurest::Field::DateTime,
    }

    def field(name, docusign_name = nil, type = nil)
      attr_accessor name
      if docusign_name
        alias_method docusign_name, name
        define_method("#{docusign_name}=") do |value|
          value = if type.is_a?(Proc)
            type.call value
          elsif CONVERSION.key?(type)
            CONVERSION[type].new(value).convert
          else
            value
          end
          send("#{name}=", value)
        end
      end
    end

    def association(klass, parent_field = nil, &block)
      singular = klass[-1] == 's' ? klass[0..-2] : klass

      define_method(klass) do
        instance_variable_get(:"@#{klass}") ||
          instance_variable_set(:"@#{klass}", persisted? ? instance_eval(&block) : [])
      end
      define_method("#{klass}=") do |values|
        values.each { |value| send "add_#{singular}", value }
      end
      define_method("add_#{singular}") do |value|
        values = send(klass)

        value.send("#{parent_field}=", guid) if parent_field
        value.id = values.length + 1 unless value.id
        values << value
      end
    end
  end
end
