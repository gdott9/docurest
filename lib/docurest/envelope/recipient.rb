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

    association(:tabs) { Docurest::Envelope::Recipient::Tab.list(envelope_id, guid) }

    def to_h
      {recipientId: recipientId}
    end
  end
end
