require_relative "../../lib/networker/facade/http"
require_relative "../../lib/networker/client/http"

RSpec.describe Networker::Facade::Http do
  describe "#get" do
    let(:client) { double(Networker::Client::Http) }
    subject { Networker::Facade::Http.req(options) }

    context "when options are valid" do
      context "when option means 'GET request'" do
        let(:options) do
          {
            "method" => "GET",
            "scheme" => "http",
            "host" => "example.com",
            "path" => "/example",
            "headers" => {},
            "options" => {}
          }
        end
        let(:url) { [options["scheme"], options["host"]].join("://") + options["path"] }
        let(:headers) { options["headers"] }
        let(:req_options) { options["options"] }
        let(:response) do
          {
            status: 200,
            headers: "Content-Type: text/html; charset=utf-8",
            body: "<html><body><h1>Hello World</h1></body></html>"
          }
        end
        before do
          allow(Networker::Client::Http).to receive(:new).with(url, headers, req_options).and_return(client)
          allow(client).to receive(:get)
          [:status, :headers, :body].each do |mock_key|
            allow(client).to receive(mock_key).and_return(response[mock_key])
          end
        end
        it "should respond as json case" do
          subject

          expect(Networker::Client::Http).to have_received(:new).with(url, headers, req_options)
          expect(client).to have_received(:get)
        end
      end
    end

    context "when options are invalid" do
      context "when method does not support" do
        let(:options) do
          { method: "INVALID" }
        end
        
        it "should raise error" do
          expect { subject }.to raise_error
        end
      end
    end
  end
end