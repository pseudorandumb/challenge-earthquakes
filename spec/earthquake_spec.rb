require_relative '../environment'

describe Earthquake do
  before(:all) do
    Earthquake.destroy_all
    @sample_json = JSON.parse(File.read("sample_data.json"))["features"].slice(0,10)
    @earthquake = {:earthquake_id=>"hv61184171", :magnitude=>1.84, :place=>"3km SSE of Pahala, Hawaii", :time=>DateTime.strptime(@sample_json[0]['properties']['time'].to_s,'%Q'), :longitude=>-155.4606628, :latitude=>19.1774998, :depth=>33.97}
  end
  it "should retrieve and parse Earthquakes" do
    allow(Earthquake).to receive(:retrieve_earthquake_data).and_return(@sample_json)
    data = Earthquake::transform_geo_data(Earthquake::retrieve_earthquake_data)

    expect(data[0]).to eq(@earthquake)
  end

  it "should save to the DB" do
    allow(Earthquake).to receive(:retrieve_earthquake_data).and_return(@sample_json)
    results = Earthquake::update_stored_earthquakes
    expect(Earthquake.first["earthquake_id"]).to eq(@earthquake[:earthquake_id])
  end

  it "should not create duplicates in DB when updating (id is unique)" do
    sample_total = @sample_json.count
    allow(Earthquake).to receive(:retrieve_earthquake_data).and_return(@sample_json)
    Earthquake::update_stored_earthquakes
    expect(Earthquake.count).to eq(sample_total)
    Earthquake::update_stored_earthquakes
    expect(Earthquake.count).to eq(sample_total)
  end
end