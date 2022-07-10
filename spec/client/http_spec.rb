require_relative "../../lib/networker/client/http"

RSpec.describe Networker::Client::Http do
  shared_examples_for "response html with status" do |status|
    it do
      subject
      expect(client.status).to eq status
      expect(client.headers).to include({ "content-type" => "text/html;charset=utf-8" })
    end
  end

  describe "#get" do
    let(:client) { Networker::Client::Http.new(url, req_headers, options) }
    subject { client.get(query) }
    
    context "when request only url" do
      let(:url) { "http://localhost:3000/example/html" }
      let(:req_headers) { {} }
      let(:options) { {} }
      let(:query) { nil }

      it_should_behave_like "response html with status", 200
      it "should success response html" do
        subject
        expect(client.body).to include "This is for HTML Test"
      end
    end

    context "when request with query" do
      let(:url) { "http://localhost:3000/example/html" }
      let(:req_headers) { {} }
      let(:options) { {} }
      let(:query) { { first_name: "yamada", last_name: "taro", additional: "more-query" } }

      it_should_behave_like "response html with status", 200
      it "should response with passed query" do
        subject
        ["yamada", "taro"].each do |expected|
          expect(client.body).to include expected
        end
        expect(client.body).not_to include "more-query"
      end
    end

    context "when request failed" do
      let(:url) { "http://localhost:3000/doesnotexist" }
      let(:req_headers) { {} }
      let(:options) { {} }
      let(:query) { nil }

      it_should_behave_like "response html with status", 404
      it "should response with 404" do
        subject
        expect(client.body).to include "404 NOT FOUND"
      end
    end
  end
end