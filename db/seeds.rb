# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'
require 'date'
class RootData
    $dirName = "#{Rails.root}/db/seeddata"
    def self.station_data_from_json
        univ_data = Univ.all
        univ_data.each do |univ|
            station_data = JSON.parse(File.read("#{$dirName}/retestData/#{univ.name}.json"))
            result = station_data["resultList"]
            result.each do |x|
                Station.create(gpsX: x["gpsX"],
                               gpsY: x["gpsY"],
                               stationNm: x["stationNm"],
                               stationId: x["stationId"],
                               arsId: x["arsId"],
                               univ_id: univ.id)
                puts x["stationNm"]
            end
            
        end
    end
    
    def self.univ_data_from_json
        data = JSON.parse(File.read("#{$dirName}/univ.json"))
        result = data["result"]
        result.each do |x|
            Univ.create(name: x["name"],
                       fest_s: x["fest_s"].to_time,
                       fest_e: x["fest_e"].to_time,
                       lineup: x["lineup"],
                       gpsX: x["gpsX"],
                       gpsY: x["gpsY"],
                       radius: x["radius"],
                       univ_mark: x["univ_mark"]
                       )
        end
    end
    def self.insert_bus_data
        data = JSON.parse(File.read("#{$dirName}/busData.json"))
        result = data["resultList"]
        result.each do |r|
            Bus.create(busRouteId: r["busRouteId"],
                       busRouteNm: r["busRouteNm"]
                       )
            puts r["busRouteNm"]
       end
    end
end
RootData.univ_data_from_json
RootData.station_data_from_json
RootData.insert_bus_data