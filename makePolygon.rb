require 'geometry'
require './grahamScan.rb'

def makePolygon raw
  include Geometry

  features = []
  points = []
  
  # Run through all of the raw data and generate points for the map ( features )
  # and a simple array of points ( points )

  raw.map do |point| 
    lat = point['lat']
    lng = point['lng']

    points.push( Point(lng.to_f,lat.to_f ) )

    features.push( 
      { "type" => "Feature",
         "geometry" => {
           "type" => "Point", 
           "coordinates" => [lng.to_f,lat.to_f ]
          },
         "properties"=> { "precinct" => point['precinct'] }
       }
    )

  end
  
  polygon = ConvexHull.calculate( points )
  
  # Add the polygon to the map
  shape = polygon.map{ |v| [v.x, v.y] }
  
  features.push(
    { "type" => "Feature",
      "geometry" => {
        "type" => "Polygon",
        "coordinates" => [ shape ]
      },
      "properties" => {'precinct' => raw[0]['precinct'] }
    }
  )

  return features
end
def clockSort( a,b,center_x,center_y)
  det = (a.x-center_x) * (b.y-center_y) - (b.x - center_x) * (a.y - center_y)
   if det < 0
    return 1
   elsif det > 0
    return -1
   else
     int d1 = (a.x-center.x) * (a.x-center_x) + (a.y-center_y) * (a.y-center_y);
     int d2 = (b.x-center.x) * (b.x-center_x) + (b.y-center_y) * (b.y-center_y);
     return d1 <=> d2
  end
end