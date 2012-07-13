require 'geometry'

def makePolygon raw
  include Geometry

  features = []
  points = []
  
  # Run through all of the raw data and generate points for the map ( features )
  # and a simple array of points ( points )

  raw.map do |point| 
    lat = point['lat']
    lng = point['lng']

    points.push( [ lng.to_f,lat.to_f ] )

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
  
  # Find the max & min lat lng
  all_lats = points.map{ |point| point[1] }
  maxLat = points[ all_lats.index( all_lats.max ) ]
  minLat = points[ all_lats.index( all_lats.min ) ]

  all_lng = points.reject{ |point| point == maxLat || point == minLat }.map{ |point| point[0] }
  maxLng = points.reject{ |point| point == maxLat || point == minLat }[ all_lng.index( all_lng.max ) ]
  minLng = points.reject{ |point| point == maxLat || point == minLat }[ all_lng.index( all_lng.min ) ]
  
  # Creating a polygon based off these maximums
  polygon = Polygon.new( 
    [ 
      Point( maxLat[0],maxLat[1] ), 
      Point( maxLng[0],maxLng[1] ), 
      Point( minLat[0],minLat[1] ), 
      Point( minLng[0],minLng[1] )
    ]
  )
  
  # Run through every point and see if fits in polygon
  points.each do |point|
    point = Point(point[0],point[1])
  
    if !polygon.contains?( point ) 
      # Adding new point to the polygon - adding points clockwise from http://stackoverflow.com/questions/6989100/sort-points-in-clockwise-order
      
      old_points = polygon.vertices
      old_points.push( point )
      center_x = 0
      all_x = old_points.each{ |point| center_x += point.x }
      center_x = center_x / all_x.length
      
      center_y = 0 
      all_y = old_points.each{ |point| center_y += point.y }
      center_y = center_y / all_x.length
      
      old_points.sort{ |a,b| clockSort(a,b,center_x,center_y) }

      
      polygon = Polygon.new(old_points)
    end
  
  end
  
  
  # Add the polygon to the map
  shape = polygon.vertices.map{ |v| [v.x, v.y] }
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