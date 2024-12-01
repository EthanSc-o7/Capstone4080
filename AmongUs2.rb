require 'gosu'
require_relative 'Player.rb'
require './Star.rb'
require './Time.rb'
  module ZOrder 
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

 class Game < Gosu::Window
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
        if Gosu.button_down? Gosu::KB_A or Gosu::button_down? Gosu::GP_LEFT
          @player.turn_left
        end

        if Gosu.button_down? Gosu::KB_D or Gosu::button_down? Gosu::GP_RIGHT
          @player.turn_right
        end

        if Gosu.button_down? Gosu::KB_W or Gosu::button_down? Gosu::GP_BUTTON_0
          @player.accelereate
        end
        @player.move
      
      end
      if @player2.getID == 2
        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
          @player2.turn_left
        end

        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
          @player2.turn_right
        end

        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
          @player2.accelereate
        end
        @player2.move
      end

      @player.collect_stars(@stars)
      @player2.collect_stars(@stars) 
      if rand(100) < 6 and @stars.size < 40 
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
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI,1.0,1.0, Gosu::Color::GREEN)
    @font.draw_text("Score: #{@player2.score}", 890, 10, ZOrder::UI,1.0,1.0, Gosu::Color::RED)
    @font.draw_text("Time Left: #{@timer.seconds}", 445, 10, ZOrder::UI,1.0,1.0, Gosu::Color::WHITE)

    if @timer.seconds == 0 
      if @player.score > @player2.score
        @font.draw_text_rel("Player 1 Wins: #{@player.score}", @width / 2, @height / 2, 1, 0.5, 0.5)
      else
        @font.draw_text_rel("Player 2 Wins: #{@player2.score}", @width / 2, @height / 2, 1, 0.5, 0.5)
      end

      @font.draw_text_rel("Press Space to play again", @width / 2, @height / 1.5, 1, 0.5, 0.5)
    end 
  end 

  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close 
    elsif id == Gosu::KB_SPACE
      Game.new.show
      close
    else 
      super 
    end
  end 

end 

Game.new.show