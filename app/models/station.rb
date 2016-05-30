require 'open-uri'
require 'mailgun'
class Station < ActiveRecord::Base
    belongs_to :univ
    def self.get_route_data (f_univ_name, t_univ_name)
        uri = "http://ws.bus.go.kr/api/rest/pathinfo/getPathInfoByBus?ServiceKey=my service key"
        f_univ_data = Univ.where(name: f_univ_name).first.station
        t_univ_data = Univ.where(name: t_univ_name).first.station
        pre_count = 0;
        f_univ_data.each do |f_univ|
            t_univ_data.each do |t_univ|
                uri = uri+"&startX=#{f_univ.gpsX}&startY=#{f_univ.gpsY}&endX=#{t_univ.gpsX}&endY=#{t_univ.gpsY}&numOfRows=999&pageNo=1"
                result_hash = Hash.from_xml(HTTP.get(URI.parse(uri)).to_s)
                next if(result_hash["ServiceResult"]["msgHeader"]["itemCount"] == "0")
                now_count = result_hash["ServiceResult"]["msgHeader"]["itemCount"]
                if(now_count > pre_count)
                    @result = result_hash["ServiceResult"]["msgBody"]["itemList"]
                end
            end
        end
        @result
    end
    
    def self.send_route_info_lack(from_univ, to_univ)
        result_message = ""
        mail_contents = "#{from_univ}에서 #{to_univ}로 가는 노선 정보가 매우 부족하거나 혹은.\n"+
                        "정보가 잘못되었습니다. 확인하시기 바랍니다."

        mg_client = Mailgun::Client.new("my api key")
        
        message_params =  {
                           from:    'admin@likelion.net',
                           to:      'skyhan1106@gmail.com',
                           subject: "From #{from_univ} to #{to_univ} has LITTLE INFO error",
                           text:   mail_contents
                          }
        
        mg_client.send_message('my domain', message_params).to_h!
        result_message = "오류정보가 전달되었습니다.\n 빠른 시간 안에 해결하겠습니다.\n감사합니다."
    end
end
