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
    let(:client) { Networker::Client::Http.new(url, req_headers, params) }
    subject { client.get }
    
    context "when request only url" do
      let(:url) { "http://localhost:3000/example/html" }
      let(:req_headers) { {} }
      let(:params) { nil }

      it_should_behave_like "response html with status", 200
      it "should success response html" do
        subject

        expect(client.body).to include "This is for HTML Test"
      end
    end

    context "when request with query" do
      let(:url) { "http://localhost:3000/example/html" }
      let(:req_headers) { {} }
      let(:params) { { first_name: "yamada", last_name: "taro", additional: "more-query" } }

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
      let(:params) { nil }

      it_should_behave_like "response html with status", 404
      it "should response with 404" do
        subject
        expect(client.body).to include "404 NOT FOUND"
      end
    end
  end

  describe "#post" do
    let(:client) { Networker::Client::Http.new(url, req_headers, params) }
    let(:url) { "http://localhost:3000/example/machine" }
    let(:req_headers) { {} }
    subject { client.post }

    context "when request success" do
      let(:params) { { nut: 3, iron_plate: 5 } }
      
      it_should_behave_like "response html with status", 201
      it "should response with 201" do
        subject
        expect(client.body).to include "machine created"
      end
    end

    context "when request failed because body is invalid" do
      let(:params) { { walnut: 3 } }
      
      it_should_behave_like "response html with status", 400
      it "should response with 400" do
        subject
        expect(client.body).to include "400 Bad Request"
      end
    end
  end
end