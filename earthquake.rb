require './environment'

class Earthquake < ActiveRecord::Base
  scope :dangerous_places, lambda { |num_places, num_days| where("time > ?", num_days.days.ago).order(magnitude: :desc).limit(num_places) }

  def to_hash
    self.as_json
  end

  def self.update_stored_earthquakes
    newData = transform_geo_data(retrieve_earthquake_data)
    newData.each do |earthquake_data|
      earthquake = find_or_initialize_by(earthquake_id: earthquake_data[:earthquake_id])
      earthquake.update(earthquake_data)
    end
  end

  def self.transform_geo_data(earthquakes)
    earthquakes.map do |data|
      {
        "earthquake_id": data['id'],
        "magnitude": data['properties']['mag'],
        "place": data['properties']['place'],
        "time": DateTime.strptime(data['properties']['time'].to_s,'%Q'),
        "longitude": data['geometry']['coordinates'][0],
        "latitude": data['geometry']['coordinates'][1],
        "depth": data['geometry']['coordinates'][2],
      }
    end
  end

  def self.retrieve_earthquake_data
    body = Net::HTTP.get('earthquake.usgs.gov', '/earthquakes/feed/v1.0/summary/all_month.geojson')
    JSON.parse(body)["features"]
  end
end
