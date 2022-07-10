# frozen_string_literal: true

require_relative "../client/http"

module Networker
  module Facade
    class Http
      def self.req(opts)
        self.request_options = opts

        @client = Networker::Client::Http.new(@url, @headers, @options)
        client_request

        { status: @client.status, headers: @client.headers, body: @client.body }
      end

      def self.client_request
        case @method
        when "GET"
          @client.get(@options["query"])
        when "POST"
          # nope in v0.0.1
        else
          raise StandardError
        end
      end

      def self.request_options=(opts)
        @method = opts["method"]
        @url = [opts["scheme"], opts["host"]].join("://") + opts["path"]
        @headers = opts["headers"]

        options = opts["options"].nil? ? {} : opts["options"]
        @options = options
      end

      private_class_method :request_options=

      private

      attr_reader :client, :method, :url, :headers, :options
    end
  end
end
