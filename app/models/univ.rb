class Univ < ActiveRecord::Base
    has_many :station
    def self.univ_data
        univ = Univ.all
    end
    def self.result_array
        result_array = Array.new
        Univ.all.each do |x|
          next if(x.fest_s.nil?)
          if(Time.current.to_date.between?(x.fest_s, x.fest_e))
            result_array << x
          end
        end  
        result_array
    end
    
end
