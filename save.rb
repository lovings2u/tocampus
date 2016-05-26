require 'json'
class Pop
    def self.check_route(dir_name, from_name, to_name)
        from_json = JSON.parse(File.read("#{from_name}"))
        to_json = JSON.parse(File.read("#{to_name}"))
        
        from_data = from_json["resultList"]
        from_array = from_data.map {|m| m["stationNm"]}
        to_data = to_json["resultList"]
        to_array = to_data.map {|m| m["stationNm"]}
        
        
        
        path_array = Array.new
        short_array = Array.new
        index = 0
        from_array.each do |from|
            to_array.each do |to|
                index+=1
                begin
                route_json = JSON.parse(File.read("#{dir_name}/#{index}_#{from}-#{to}.json"))
                route_data = route_json["resultList"]
                
                path_data = route_data.map {|n| n["pathList"]}
                distance_data = route_data.map {|n| n["distance"]}
                time_data = route_data.map {|n| n["time"]}
                each_path_data = Array.new
                path_data.zip(distance_data.each, time_data.each).each do |x,y,z|
                    next if(x.count > 3)
                    
                    if(x.count == 1)
                        each_path_data << [[x[0]["routeNm"],x[0]["fname"],x[0]["tname"]],y, z]
                    else 
                        each_path_data << [[x[0]["routeNm"],x[0]["fname"],x[0]["tname"]],
                                        [x[1]["routeNm"],x[1]["fname"],x[1]["tname"]],y, z]
                    end
                end
                each_path_array = each_path_data.uniq
                puts each_path_array
                rescue
                    next
                end
                break
            end
        end
        
    end
end

dir_name = "routeData/경기대학교 서울캠퍼스-삼육대학교"
from_name = "경기대학교 서울캠퍼스.json"
to_name = "삼육대학교.json"

array = Pop.check_route(dir_name, from_name, to_name)