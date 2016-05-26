require 'json'
class HomeController < ApplicationController
  def index
    @result_array = Univ.result_array
    @univ = Univ.univ_data
  end
  def bus
    route = Station.get_route_data(params[:from], params[:to])
    
    @path_list = Array.wrap(route)
    
    puts @path_list
    @f_univ = params[:from]
    @t_univ = params[:to]
    @sta_pattern = /.+(?=\()/
    @bus_pattern = /(?<=\s).+(?=번)/
    @num_pattern = /(?<=\().+(?=\))/
    @sta_num_pattern = /(?<=\().+(?=\))/
  end

  def result
    bus_number = params[:bus_route_id]
    station_id = params[:station_id]
    
    bus_route_id = Bus.where(busRouteNm: bus_number).first.busRouteId
    messages = Array.new
    bus_number.zip(station_id.each).each do |bus, sta|
      bus_route_id = Bus.where(busRouteNm: bus).first.busRouteId
      result =Bus.check_bus_time(sta, bus_route_id)
      station_name = result[0]["stNm"]
      bus_time = result[0]["arrmsg1"]
      messages << [bus, station_name, bus_time]
    end
    puts messages
    render_message = ""
    messages.each do |m| 
      render_message += "[#{m[0]}] / #{m[1]} - #{m[2]}\n"
    end
    render text: render_message
  end

  def support
    
    begin
      puts params[:error_type]
      case params[:error_type]
        when "1" then 
          @result_message = Bus.send_bus_time_error(params[:funiv_id], params[:tuniv_id], params[:sta_data], params[:bus_data], params[:route_index])
        when "2" then 
          @result_message = Station.send_route_info_lack(params[:funiv_id], params[:tuniv_id])
        else 
      end
    rescue
      @result_message = "오류정보 전송이 실패하였습니다.\n다시 시도해주세요.\n 감사합니다."
    end
    render text: @result_message
  end
end
