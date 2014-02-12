require 'nokogiri'

f = File.open("ucd.unihan.flat.xml")
unihan = Nokogiri::XML(f)
f.close