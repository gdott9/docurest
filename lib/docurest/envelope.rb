module Docurest
  class Envelope < Docurest::Base
    def self.list_status(from_date:, status: 'Any')
      result = Docurest.client.get "/envelopes/status",
        from_date: from_date, status: 'Any'
      result['envelopes'].map { |envelope| new envelope }
    end

    def self.list(from_date:, status: 'Any')
      result = Docurest.client.get "/envelopes",
        from_date: from_date, status: status
      result['envelopes'].map { |envelope| new envelope }
    end

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
    field :status_at, :statusDateTime, :date_time
    field :status_changed_at, :statusChangedDateTime, :date_time

    field :voided_reason, :voidedReason

    field :custom_fields, :customFields

    field :email_settings, :emailSettings, ->(value) { Docurest::Envelope::EmailSettings.new value }

    association(:recipients, :envelope_id) { Docurest::Envelope::Recipient.list(guid) }
    def save_recipients(resend: false)
      Docurest::Envelope::Recipient.save recipients, resend: resend
    end

    association(:documents, :envelope_id) { Docurest::Envelope::Document.list(guid) }

    def audit_event
      Docurest.client.get "/envelopes/#{guid}/audit_events"
    end

    def email_settings
      @email_settings ||= Docurest::Envelope::EmailSettings.new(envelope_id: guid).fetch
    end

    def fetch
      self.attributes = Docurest.client.get "/envelopes/#{guid}" if persisted?
      self
    end

    def download(file, document_id = :combined)
      Docurest::Envelope::Document.new(id: document_id, envelope_id: guid).download(file)
    end

    def resend
      return unless persisted? && %w{sent delivered}.include?(status)
      Docurest.client.put "/envelopes/#{guid}", {request_query: {resend_envelope: true}}
    end

    def fire
      return unless status == 'created'

      if persisted?
        Docurest.client.put "/envelopes/#{guid}", {status: :sent}
      else
        self.status = :sent
      end
    end

    def void(reason = 'No reason provided.')
      Docurest.client.put "/envelopes/#{guid}", {status: :voided, voidedReason: reason}
    end

    def save(resend: false)
      result = if persisted?
        Docurest.client.put "/envelopes/#{guid}", to_h.merge(request_query: {resend_envelope: resend})
      else
        Docurest.client.post "/envelopes", to_h
      end
      self.attributes = result
    end

    def to_h
      {
        status: status,
        emailSubject: emailSubject,
        emailBlurb: emailBlurb,
        emailSettings: emailSettings.to_h,
      }.tap do |hash|
        if documents_changed?
          hash[:documents] = documents.map(&:to_h)
          hash[:files] = files
        end
        hash[:recipients] = Docurest::Base.hash_by_type(recipients) if recipients_changed?
      end
    end

    private

    def files
      Hash[documents.map(&:upload)]
    end
  end
end
