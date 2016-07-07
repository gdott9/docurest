module Docurest
  module Field
    class DateTime < Docurest::Field::Base
      def convert
        ::DateTime.parse(value)
      end
    end
  end
end
