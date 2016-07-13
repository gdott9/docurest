module Docurest
  class Envelope::EmailSettings < Docurest::Base
    field :envelope_id
    field :name, :replyEmailNameOverride
    field :email, :replyEmailAddressOverride
    field :bcc, :bccEmailAddresses
    field :persisted

    def delete
      return unless envelope_id
      Docurest.client.delete url, parse_json: false
    end

    def fetch
      return self unless envelope_id
      result = Docurest.client.get url

      unless result.key?("errorCode")
        self.attributes = result
        self.persisted = true
      end

      self
    end

    def save
      return unless envelope_id
      if persisted?
        Docurest.client.put url, to_h
      else
        Docurest.client.post url, to_h
      end
    end

    def to_h
      {
        replyEmailAddressOverride: replyEmailAddressOverride,
        replyEmailNameOverride: replyEmailNameOverride
      }
    end

    private

    def url
      "/envelopes/#{envelope_id}/email_settings"
    end
  end
end
