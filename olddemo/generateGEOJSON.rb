require 'json'
require 'geometry'

include Geometry

data = open('data.json')
string = ''

data.each{ |f| string += f }

raw = JSON::parse(string)
points = []
geojson = { 
  "type" => "FeatureCollection",
  "features" => [ ]
}


raw.map do |point|
  if point['latlng'].index('-')
    lat = point['latlng'].split('-')[0]
    lng = '-'+point['latlng'].split('-')[1]
  else
    decimal = point['latlng'].index('.')
    lat = point['latlng'].slice(0,decimal+3)
    lng = point['latlng'].slice(decimal+3,point['latlng'].length)
  end

  points.push( [ lng.to_f,lat.to_f ] )

  geojson['features'].push( 
    { "type" => "Feature",
       "geometry" => {
         "type" => "Point", 
         "coordinates" => [lng.to_f,lat.to_f ]
        },
       "properties"=> {"districts" => point['data'] }
     }
  )
  
end

polygon = Polygon.new( [ Point(points[0][0],points[0][1]), Point(points[1][0],points[1][1]), Point(points[2][0],points[2][1]), Point(points[3][0],points[3][1])  ] )



points.each do |point|
  point = Point(point[0],point[1])

  if !polygon.contains?( point )
    old_points = polygon.vertices.push( point ).sort{ |a,b| a.x <=> b.x &&  a.y <=> b.y }
    polygon = Polygon.new(old_points)
  end
  
end


shape = polygon.vertices.map{ |v| [v.x, v.y] }
geojson['features'].push(
  { "type" => "Feature",
    "geometry" => {
      "type" => "Polygon",
      "coordinates" => [ shape ]
    },
    "properties" => {}
  }
)






file = File.new("myshape.json", "w")
file.write(geojson.to_json)
file.close

