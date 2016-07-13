module Docurest
  class Envelope::Recipient::Tab < Docurest::Base
    def self.list(envelope_id, recipient_id)
      result = Docurest.client.get "/envelopes/#{envelope_id}/recipients/#{recipient_id}/tabs"

      result.each_with_object([]) do |(type, tabs), all_tabs|
        all_tabs.concat(tabs.map { |tab| new tab.merge(type: type) })
      end
    end

    field :guid
    field :name
    field :type
    field :tab_label, :tabLabel
    field :scale_value, :scaleValue, :float
    field :optional, nil, :boolean
    field :required, nil, :boolean
    field :document_id, :documentId
    field :page_number, :pageNumber, :integer
    field :recipient_guid, :recipientId

    field :x, :xPosition
    field :y, :yPosition
    field :anchor, :anchorString
    field :anchor_x_offset, :anchorXOffset
    field :anchor_y_offset, :anchorYOffset
    field :anchor_units, :anchorUnits

    def to_h
      {
        name: name,
        tabLabel: tabLabel,
        scaleValue: scaleValue,
        optional: optional,
        required: required,
        documentId: documentId,
        pageNumber: pageNumber,
        xPosition: xPosition,
        yPosition: yPosition,
        anchorString: anchorString,
        anchorXOffset: anchorXOffset,
        anchorYOffset: anchorYOffset,
        anchorUnits: anchorUnits,
      }
    end
  end
end

