require 'gosu'

  module ZOrder 
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

 class Tutorial < Gosu::Window
  def initialize

    super 1024,720
    self.caption = "Among Us 2"
    @background_image = Gosu::Image.new("media/space2.jpg", :tileable =>true)
    @player = Player.new(1)
    @player.warp(256,360)

    @player2 = Player.new(2)
    @player2.warp(768,360)
    @star_anim = Gosu::Image.load_tiles("media/star.png", 25,25)
    @stars = Array.new
    @timer = Time.new
    
    @font = Gosu::Font.new(30)

    @width = 1024 
    @height = 720
  end 

  def update 
    if @timer.seconds > 0
      @timer.update
      if @player.getID == 1
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
          @player.turn_left
        end

        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
          @player.turn_right
        end

        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
          @player.accelereate
        end
        @player.move
      
      end
      if @player2.getID == 2
        if Gosu.button_down? Gosu::KB_A or Gosu::button_down? Gosu::GP_LEFT
          @player2.turn_left
        end

        if Gosu.button_down? Gosu::KB_D or Gosu::button_down? Gosu::GP_RIGHT
          @player2.turn_right
        end

        if Gosu.button_down? Gosu::KB_W or Gosu::button_down? Gosu::GP_BUTTON_0
          @player2.accelereate
        end
        @player2.move
      end

      @player.collect_stars(@stars)
      @player2.collect_stars(@stars) 
      if rand(100) < 4 and @stars.size < 40 
        @stars.push (Star.new(@star_anim))
      end 

  end

    if @timer.seconds == 0 
      @player.stop
      @player2.stop
    end

  end
 


  def draw 
    @player2.draw
    @player.draw
    @background_image.draw(0,0,0)
    @stars.each{|star| star.draw}
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI,1.0,1.0, Gosu::Color::YELLOW)
    @font.draw_text("Score: #{@player2.score}", 890, 10, ZOrder::UI,1.0,1.0, Gosu::Color::YELLOW)
    @font.draw_text("Time Left: #{@timer.seconds}", 445, 10, ZOrder::UI,1.0,1.0, Gosu::Color::WHITE)

    if @timer.seconds == 0 
      if @player.score > @player2.score
        @font.draw_text_rel("Player 1 Wins: #{@player.score}", @width / 2, @height / 2, 1, 0.5, 0.5)
      else
        @font.draw_text_rel("Player 2 Wins: #{@player2.score}", @width / 2, @height / 2, 1, 0.5, 0.5)
      end
    end 
  end 

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close 
    else 
      super 
    end
  end 

end 

class Player 
  attr_reader :score

  def initialize(id)
    @image = Gosu::Image.new("media/susgreen.bmp")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
    @playerID = id
  end 

  def warp(x,y)
    @x, @y = x,y 
  end 

  def turn_left
    @angle -= 4.5 
  end

  def turn_right 
    @angle += 4.5 
  end 

  def accelereate 
    @vel_x += Gosu.offset_x(@angle,0.5)
    @vel_y += Gosu.offset_y(@angle,0.5)
  end
  def move 
    @x += @vel_x
    @y += @vel_y
    @x %= 1024 
    @y %= 720

    @vel_x *= 0.95
    @vel_y *= 0.95

  end 

  def draw
    @image.draw_rot(@x,@y,1,@angle)
  end 

  def getID
    return @playerID
  end

  def score 
    @score 
  end 

  def stop 
    @vel_x = 0
    @vel_y = 0
  end 

  def collect_stars(stars)
    stars.reject! do |star| 
      if Gosu.distance(@x,@y,star.x,star.y) < 35
        @score +=10
        true
      else 
        false 
      end
    end
  end 
end 

class Star 
  attr_reader :x, :y 

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color::BLACK.dup
    @color.red = rand(256-40) + 40
    @color.green = rand(256-40) + 40
    @color.blue = rand(256-40) + 40
    @x = rand * 1024
    @y = rand * 720 
  end 

  def draw
    img = @animation[Gosu.milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
    ZOrder::STARS, 1,1, @color, :add)
  end
end


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


Tutorial.new.show