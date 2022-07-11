# frozen_string_literal: true

require "faraday"
require "faraday/net_http"

module Networker
  module Client
    class Http
      def initialize(url, headers, params)
        Faraday.default_adapter = :net_http

        @url = url
        @req_headers = headers
        @params = params

        @status = -1
        @headers = ""
        @body = ""
      end

      def get
        self.response = Faraday.new(url: @url, params: @params, headers: @req_headers).get
      end

      def post
        self.response = Faraday.new(url: @url, headers: @req_headers).post do |f|
          f.body = @params unless @params.nil?
        end
      end

      attr_reader :status, :headers, :body

      private

      def response=(res)
        @status = res.status
        @headers = res.headers
        @body = res.body
      end

      attr_reader :client, :url, :req_headers, :params
    end
  end
end
