require './environment'

def mostDangerousPlaces(num_places, num_days)
  earthquakes = Earthquake.dangerous_places(num_places, num_days)
  adjust_spacing = 40
  puts "PLACE".ljust(adjust_spacing+1) + "EQ-MAGNITUDE"
  earthquakes.each do |earthquake|
    puts "#{earthquake.place.ljust(adjust_spacing)} #{earthquake.magnitude}"
  end
end

mostDangerousPlaces(ARGV[0].to_i, ARGV[1].to_i)