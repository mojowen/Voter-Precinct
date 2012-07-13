Can you create a polygon representing a Voting precincts from Voter's Addresses?
===

Here's the problem: There is no* national Voter Precinct Shapefile. Meaning we (democracy advocates) cannot take a Latitude and Longitude and use it to look up in any sort of national way.

So I had an idea about how to generate one.

*That I can discover. Happy to be wrong about this

The background
====

I have exported and geocoded ~300 voters from Portland, OR. This data is in `voters.json`. Each voter is comprised up of the following properties:

`{
	"precinct":"4503", // Their precinct (what I'm using to group them)
	"cd":"3", // Congressional District (not important)
	"sd":"23", // State Senate District (not important)
	"hd":"45", // State House District (not important)
	"lat":45.54042460339, // Latitude, as geocoded by BatchGEO
	"lng":-122.61466057273 // Longitude, as geocoded by BatchGEO
}`

I then run this data through `generateGEOJSON.rb` ( to do this just use your console and run ` bundle install ` then `ruby generateGEOJSON.rb `) to generate ` myshape.json ` which is a geojson file.

To view the geojson file view the following URL on your local machine (http://127.0.0.1/GeoJSON-Viewer/index.html?url=http://localhost/~scott/GeoJSON-Viewer/myshape.json&type=geojson)[http://127.0.0.1/GeoJSON-Viewer/index.html?url=http://localhost/~scott/GeoJSON-Viewer/myshape.json&type=geojson]

Mapping Points to Polygon
====

The polygon takes place inside of the `makePolygon.rb` file. Right now this is pretty crude and imperfect. Here's how it works:

1. Get all the points and put em in the GeoJSON
2. Use a (Graham Scan)[http://en.wikipedia.org/wiki/Graham_scan] to compute a polygon based on the points. Graham Scan algorithm from (Branch14.org by Phil Hofmann)[http://branch14.org/snippets/convex_hull_in_ruby.html]

This works pretty well. Obviously more points => better polygons.

