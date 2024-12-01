class Time
  attr_reader :seconds

  def initialize
    @seconds = 60
    @last_Time  = Gosu::milliseconds()
    
  end 

  def update
    if (Gosu::milliseconds - @last_Time) / 1000 == 1 
      @seconds -= 1
      @last_Time = Gosu::milliseconds()
    end 
  end

  def seconds 
    @seconds
  end 
end