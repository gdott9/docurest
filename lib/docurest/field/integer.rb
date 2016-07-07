module Docurest
  module Field
    class Integer < Docurest::Field::Base
      def convert
        value.to_i
      end
    end
  end
end
