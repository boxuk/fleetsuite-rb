require_relative "../lib/fleetsuite"

describe Fleetsuite::Client do
    
  let (:client) { Fleetsuite::Client.new("boxuk", "API_TOKEN") }

  describe "instantiating a new client instance" do
    it "returns the correct endpoint" do
      expect(client.endpoint).to eq("https://boxuk.fleetsuite.com/api/v1")
    end
    
    it 'returns the correct account' do
      expect(client.token).to eq("API_TOKEN")
    end
    
    it 'returns the correct subdomain' do
      expect(client.subdomain).to eq("boxuk")
    end
  end
end