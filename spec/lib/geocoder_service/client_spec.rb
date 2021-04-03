RSpec.describe GeocoderService::Client, type: :client do
  subject { described_class.new(connection: connection) }


  let(:status) { 200 }
  let(:headers) { {'Content-Type' => 'application/json'} }
  let(:body) { {} }
  
  before do
    stubs.post('/') { [status, headers, body.to_json] }
  end


  # describe '#geocode_later valid city' do
  #   let(:status) { 200 }
  #   let(:body) { [45.05,90.05].to_json  } 
  #   let(:ad) { create(:ad, city: 'invalid.city') }
    
  #   it 'returns user id' do
  #     expect(subject.geocode_later(ad)).to eq(JSON.parse(body))
  #   end
  # end
  
  # describe '#geocode_later invalid city' do
  #   let(:status) { 204 }
  #   let(:body) { [nil,nil].to_json } 
  #   let(:ad) { create(:ad, city: 'invalid.city') }

  #   it 'returns user id' do
  #     expect(subject.geocode_later(ad)).to eq(JSON.parse(body))
  #   end
  # end
end
