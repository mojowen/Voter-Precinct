require 'json'
require './makePolygon.rb'



data = open('voters.json')
string = ''

data.each{ |f| string += f }

raw = JSON::parse(string)
precinctsData = {}
precincts = []

raw.each do |point|
  if precinctsData[ point['precinct'] ].nil?
    precinctsData[   point['precinct'] ] = [ point ]
    precincts.push( point['precinct'] )
  else 
    precinctsData[ point['precinct'] ].push(point)
  end
end


geojson = { 
  "type" => "FeatureCollection",
  "features" => [ ]
}


precincts.each do |p|
  geojson['features'].concat( makePolygon( precinctsData[p] ) )
end




file = File.new("myshape.json", "w")
file.write(geojson.to_json)
file.close

