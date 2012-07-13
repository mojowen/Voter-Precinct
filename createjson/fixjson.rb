
require 'json'

data = open('voters.json')
string = ''

data.each{ |f| string += f }

raw = JSON::parse(string)

fixed = raw.map do |voter|
  dwid = voter['d'].index('sp;')
  first = voter['d'].slice( dwid+3, voter['d'].length )
  first.slice(0,first.index('<')) +', '+voter['lt'].to_s+'|'+voter['ln'].to_s
end


file = File.new('both.csv','w')
file.write(fixed.join("\n") )
file.close
