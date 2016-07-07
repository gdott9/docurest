module Docurest
  class Envelope::EmailSettings < Docurest::Base
    field :name, :replyEmailNameOverride
    field :email, :replyEmailAddressOverride
    field :bcc, :bccEmailAddresses

    def to_h
      {
        replyEmailAddressOverride: replyEmailNameOverride,
        replyEmailNameOverride: replyEmailNameOverride
      }
    end
  end
end
