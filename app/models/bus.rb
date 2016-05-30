require 'json'
require 'net/http'
require 'mailgun'

class Bus < ActiveRecord::Base
    
    def self.check_bus_time (st_route_id, bus_route_id)
        iconv = Iconv.new('utf8', 'euckr')
        uri = "http://m.bus.go.kr/mBus/bus/getStationByUid.bms"
        result = Net::HTTP.post_form(URI.parse(uri), {"arsId" => st_route_id})
        rawbody = iconv.iconv(result.body)
        result_json = JSON.parse(rawbody)
        
        @station_data = result_json["resultList"].select {|r| r["busRouteId"] == bus_route_id}
    end
    
    def self.send_bus_time_error(from_univ, to_univ, sta_route_id, bus_route_id, route_id)
        puts "here"
        contents = "#{from_univ}에서 #{to_univ}로 가는 노선 정보중에서 \n"+
                        "#{route_id}번쨰로 검색되는 노선 도착시간 확인이 실패했습니다. \n"+
                        "정류장 정보는 #{sta_route_id} 이며 버스 정보는 #{bus_route_id}입니다."
        result_message = ""
        
        mg_client = Mailgun::Client.new("my-api-key")
        message_params =  {
                           from:    'admin@tocampus.com',
                           to:      'skyhan1106@gmail.com',
                           subject: "From #{from_univ} to #{to_univ} bus time error",
                           text:   contents
                          }
        mg_client.send_message('my domain', message_params).to_h!
        puts "success"
        result_message = "오류정보가 전달되었습니다.\n 빠른 시간 안에 해결하겠습니다.\n감사합니다."
    end
end
