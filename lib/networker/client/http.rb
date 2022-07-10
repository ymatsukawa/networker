# frozen_string_literal: true

require "faraday"
require "faraday/net_http"

module Networker
  module Client
    class Http
      def initialize(url, req_headers, options)
        Faraday.default_adapter = :net_http

        @status = -1
        @headers = ""
        @body = ""

        @url = url
        @req_headers = req_headers
        @options = options
      end

      def get(query = nil)
        params = query.nil? ? {} : query
        client = Faraday.new(url: @url, params: params, headers: @req_headers)
        self.response = client.get
      end

      def post(body = nil)
        # nope in v0.0.1
      end

      attr_reader :status, :headers, :body

      private

      def response=(res)
        @status = res.status
        @headers = res.headers
        @body = res.body
      end

      attr_reader :url, :req_headers, :options
    end
  end
end
