require_relative '../environment'

describe Earthquake do
  before(:all) do
    Earthquake.destroy_all
    @sample_json = JSON.parse(File.read("sample_data.json"))["features"].slice(0,10)
    @earthquake = {:earthquake_id=>"hv61184171", :magnitude=>1.84, :place=>"3km SSE of Pahala, Hawaii", :time=>DateTime.strptime(@sample_json[0]['properties']['time'].to_s,'%Q'), :longitude=>-155.4606628, :latitude=>19.1774998, :depth=>33.97}
    
  end

  before(:each) do
    # Mock out the external API call to the earthquake data
    allow(Earthquake).to receive(:retrieve_earthquake_data).and_return(@sample_json)
  end

  it "should retrieve and parse Earthquakes" do
    data = Earthquake::transform_geo_data(Earthquake::retrieve_earthquake_data)

    expect(data[0]).to eq(@earthquake)
  end

  it "should save to the DB" do
    Earthquake::update_stored_earthquakes
    expect(Earthquake.first["earthquake_id"]).to eq(@earthquake[:earthquake_id])
  end

  it "should not create duplicates in DB when updating (id is unique)" do
    sample_total = @sample_json.count
    Earthquake::update_stored_earthquakes
    expect(Earthquake.count).to eq(sample_total)
    Earthquake::update_stored_earthquakes
    expect(Earthquake.count).to eq(sample_total)
  end

  it "should return correct earthquakes in proper order for scope :dangerous_places" do
    Earthquake::update_stored_earthquakes
    data = Earthquake.dangerous_places(5,10)
    expect(data[0]["earthquake_id"]).to eq("us10004rjm")
    expect(data[0]["magnitude"]).to eq(5.0)
    expect(data[4]["earthquake_id"]).to eq("ak12862564")
    expect(data[4]["magnitude"]).to eq(1.8)
  end
end