require 'json'
require 'net/http'
require 'iconv'
require 'fileutils'

iconv = Iconv.new('utf8', 'euckr')
uri = "http://m.bus.go.kr/mBus/bus/getBusRouteList.bms"
result = Net::HTTP.post_form(URI.parse(uri), {"strSrch" => ""})
rawbody = iconv.iconv(result.body)

result_json = JSON.parse(rawbody)

f = File.open("busData.json", "wb")

f.write JSON.pretty_generate(result_json, :indent => "\t", :object_nl => "\n")

f.close
