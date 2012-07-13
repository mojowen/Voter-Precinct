
require 'json'

data = open('both.txt')
raw = []

data.first.split("\r").each do |row| 
    splitRow = row.split("\t")
    latlng = splitRow[4].strip().split('|')
    raw.push( {
      :precinct => splitRow[0],
      :cd => splitRow[1],
      :sd => splitRow[2],
      :hd => splitRow[3],
      :lat => latlng[0].to_f,
      :lng => latlng[1].to_f
    } )

end



# 
file = File.new('voters.json','w')
file.write(raw.to_json )
file.close
