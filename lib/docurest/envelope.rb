module Docurest
  class Envelope < Docurest::Base
    def self.get(guid)
      new(guid: guid).fetch
    end

    field :guid, :envelopeId
    field :status
    field :subject, :emailSubject
    field :body, :emailBlurb

    field :created_at, :createdDateTime, :date_time
    field :updated_at, :lastModifiedDateTime, :date_time
    field :delivered_at, :deliveredDateTime, :date_time
    field :initial_sent_at, :initialSentDateTime, :date_time
    field :sent_at, :sentDateTime, :date_time
    field :completed_at, :completedDateTime, :date_time
    field :status_changed_at, :statusChangedDateTime, :date_time

    field :custom_fields, :customFields

    field :email_settings, :emailSettings, ->(value) { Docurest::Envelope::EmailSettings.new value }

    association(:recipients) { Docurest::Envelope::Recipient.list(guid) }
    association(:documents) { Docurest::Envelope::Document.list(guid) }

    def fetch
      self.attributes = Docurest.client.get "/envelopes/#{guid}" if persisted?
      self
    end

    def download(file, document_id = :combined)
      Docurest::Envelope::Document.new(id: document_id, envelope_id: guid).download(file)
    end

    def void(reason = 'No reason provided.')
      Docurest.client.put "/envelopes/#{guid}", {status: :voided, voidedReason: reason}
    end

    def to_h
      {
        status: status,
        emailSubject: emailSubject,
        emailBlurb: emailBlurb,
        emailSettings: emailSettings.to_h,
        documents: documents.map(&:to_h),
        recipients: recipients.each_with_object({}) do |recipient, hash|
          hash[recipient.type] = recipient.to_h
        end,
        customFields: customFields || []
      }
    end
  end
end
