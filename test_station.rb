require 'json'
require 'net/http'
require 'iconv'

class Station
    def self.get_route_data (f_univ_name, t_univ_name)
        uri = "http://m.bus.go.kr/mBus/path/getPathInfoByBus.bms"
        fstation_data = Univ.where(name: f_univ_name).first
        tstation_data = Univ.where(name: t_univ_name).first
        json_data = Net::HTTP.post_form(URI.parse(uri),
                {"startX"=>fstation_data.gpxsX, "startY"=>fstation_data.gpsY, "endX"=>tstation_data.gpsX, "endY"=>tstation_data.gpsY})
        rawbody = iconv.iconv(json_data.body)
        @result_json = JSON.parse(rawbody)
    end

    def self.check_bus_time (st_route_id, bus_route_id)
        iconv = Iconv.new('utf8', 'euckr')
        uri = "http://m.bus.go.kr/mBus/bus/getStationByUid.bms"
        result = Net::HTTP.post_form(URI.parse(uri), {"arsId" => st_route_id})
        rawbody = iconv.iconv(result.body)
        result_json = JSON.parse(rawbody)
        
        station_data = result_json["resultList"].select {|r| r["busRouteId"] == bus_route_id}

        puts station_data
    end

end

Station.check_bus_time("06270","100100038")
