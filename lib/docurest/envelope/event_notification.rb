module Docurest
  class Envelope::EventNotification < Docurest::Base
    field :envelope_id
    field :envelope_events, :envelopeEvents
    field :recipient_events, :recipientEvents
    field :url
    field :logging, :loggingEnabled, :boolean

    def to_h
      {
        envelopeEvents: envelopeEvents,
        recipientEvents: recipientEvents,
        url: url,
        loggingEnabled: loggingEnabled,
      }
    end
  end
end
