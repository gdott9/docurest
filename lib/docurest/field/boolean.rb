module Docurest
  module Field
    class Boolean < Docurest::Field::Base
      def convert
        value == "true" ? true : false
      end
    end
  end
end
