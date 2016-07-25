module Docurest
  class Envelope::Recipient < Docurest::Base
    TYPES = %w{signers agents editors intermediaries carbonCopies certifiedDeliveries inPersonSigners}

    def self.list(envelope_id)
      result = Docurest.client.get "/envelopes/#{envelope_id}/recipients"
      TYPES.each_with_object([]) do |type, recipients|
        next unless result.key?(type)
        recipients.concat(result[type].map do |recipient|
          new recipient.merge(type: type, envelope_id: envelope_id)
        end)
      end
    end

    def self.save(recipients, resend: false)
      Array(recipients).group_by(&:envelope_id).each do |envelope_id, array|
        next unless envelope_id
        Docurest.client.put "/envelopes/#{envelope_id}/recipients",
          Docurest::Base.hash_by_type(array).merge(request_query: {resend_envelope: resend})
      end
    end

    field :id, :recipientId, :integer
    field :guid, :recipientIdGuid
    field :envelope_id
    field :name
    field :email
    field :custom_fields, :customFields
    field :routing_order, :routingOrder, :integer
    field :status
    field :note
    field :type
    field :signed_at, :signedDateTime, :date_time
    field :delivered_at, :deliveredDateTime, :date_time
    field :email_notification, :emailNotification, ->(value) { Docurest::Envelope::Email.new value }

    association(:tabs) { Docurest::Envelope::Recipient::Tab.list(envelope_id, guid) }

    def initialize(attributes = {})
      @type = :signers
      super
    end

    def to_h
      {
        recipientId: recipientId,
        name: name,
        email: email,
        customFields: customFields,
        routingOrder: routingOrder,
        note: note,
        tabs: Docurest::Base.hash_by_type(tabs),
      }.tap do |hash|
        hash[:emailNotification] = email_notification.to_h if email_notification
      end
    end
  end
end
