module Docurest
  class Envelope::Email < Docurest::Base
    field :subject, :emailSubject
    field :body, :emailBody
    field :language, :supportedLanguage

    def to_h
      {emailSubject: emailSubject, emailBody: emailBody, supportedLanguage: supportedLanguage}
    end
  end
end
