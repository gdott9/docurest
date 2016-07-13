require "json"
require "net/http"
require "net/http/post/multipart"

module Docurest
  class Client
    def initialize(account_id: nil, base_url: nil, env: :test)
      @account_id = account_id
      @base_url = base_url
      @env = env
    end

    def delete(url, use_base_url: true, parse_json: true, **body)
      request = Net::HTTP::Delete.new build_uri(url, use_base_url),
        {'Content-Type' => 'application/json'}
      request.body = JSON.generate(body) unless body.empty?
      query request, parse_json: parse_json
    end

    def get(url, use_base_url: true, parse_json: true, **request_query)
      uri = build_uri(url, use_base_url)
      uri.query = URI.encode_www_form(request_query)

      request = Net::HTTP::Get.new uri
      query request, parse_json: parse_json
    end

    def post(url, **attributes)
      multipart_query Net::HTTP::Post, url, **attributes
    end

    def put(url, **attributes)
      multipart_query Net::HTTP::Put, url, **attributes
    end

    private

    def multipart_query(klass, url, use_base_url: true, parse_json: true, files: {}, **body)
      uri = build_uri(url, use_base_url)
      if files.empty?
        request = klass.new uri, {'Content-Type' => 'application/json'}
        request.body = JSON.generate(body)
      else
        request = klass::Multipart.new uri, {post_body: JSON.generate(body)}.merge(files),
          {parts: {post_body: {'Content-Type' => 'application/json'}}}
      end
      query request, parse_json: parse_json
    end

    def query(request, parse_json:)
      add_authentication_header request

      res = Net::HTTP.start(request.uri.hostname, request.uri.port, use_ssl: request.uri.scheme == 'https') do |http|
        http.request request
      end

      if parse_json
        JSON.parse res.body
      else
        res.body
      end
    end

    def add_authentication_header(request)
    end

    def base_url
      @base_url ||= begin
        account = Docurest::Login.information[:accounts].detect do |acc|
          (@account_id && (acc.id == @account_id || acc.guid == @account_id)) || acc.default
        end
        if account
          @account_id = account.id
          "#{account.url}"
        else
          api_url
        end
      end
    end

    def api_url
      if @env == :production
        "https://www.docusign.net/restapi/#{API_VERSION}"
      else
        "https://demo.docusign.net/restapi/#{API_VERSION}"
      end
    end

    def build_uri(url, use_base_url = true)
      URI("#{use_base_url ? base_url : api_url}#{url}")
    end
  end
end
