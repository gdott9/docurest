module Docurest
  module Field
    class Float < Docurest::Field::Base
      def convert
        value.to_f
      end
    end
  end
end
