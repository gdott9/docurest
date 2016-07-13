module Docurest
  class Envelope::Document < Docurest::Base
    def self.list(envelope_id)
      result = Docurest.client.get "/envelopes/#{envelope_id}/documents"
      return [] unless result.key?('envelopeDocuments')

      result['envelopeDocuments'].map do |doc|
        new doc.merge(envelope_id: envelope_id)
      end
    end

    def self.delete(envelope_id, document_ids)
      document_ids = document_ids.map { |id| {documentId: id} }
      Docurest.client.delete "/envelopes/#{envelope_id}/documents", {documents: document_ids}
    end

    field :id, :documentId
    field :envelope_id
    field :name
    field :content
    field :order
    field :pages

    attr_writer :file

    def initialize(attribute = {})
      @content = 'application/pdf'
      super
    end

    def delete
      self.class.delete(envelope_id, [id])
    end

    def file
      @file ||= download(Tempfile.new(%w{docurest .pdf}))
    end

    def download(file)
      body = Docurest.client.get("/envelopes/#{envelope_id}/documents/#{id}", parse_json: false)

      if file.is_a?(String)
        File.open(file, 'wb') { |io| io << body }
      else
        file << body
      end
    end

    def upload
      ["file#{id}", UploadIO.new(file, content, name, 'Content-Disposition' => "file; documentid=#{id}")]
    end

    def to_h
      {documentId: documentId, name: name}
    end
  end
end
