require 'rubygems'
require 'gosu'
include Gosu
require 'pry'
# require_relative 'player'

WIN_W = 800
WIN_H = 800


module Colors
  Black = 0x99000000
  LightBlk = 0x33000000
  Red = 0x80ff0000
  Green = 0x8000ff00
  Blue = 0x800000ff
  Yellow = 0x80ffff00
  Orange = 0x80ff9900
  Mint = 0x8000ffbb
  BrightPurple = 0x80ff00ff
end



class MyWindow < Gosu::Window

  def initialize
    super(WIN_W, WIN_H, :fullscreen => false)
    self.caption = "Disk Profiler" # the caption method must come after the window creation "super()"
    @ctx = "start"
    @mouse_coords_txt_title = Gosu::Image.from_text( "Mouse X,Y: ", 20, {:align => :center})
    @mouse_coords_txt = 'nothing yet'
    @cur_dir_list = Dir.entries(".")
    @cur_mouse_x = 0;
    @cur_mouse_y = 0;
  end

  def update_mouse_coords
    @cur_mouse_x = self.mouse_x
    @cur_mouse_y = self.mouse_y
    @mouse_coords_txt = Gosu::Image.from_text( "#{@cur_mouse_x},#{@cur_mouse_y}", 20)
  end

  def draw
    # draw_rect(x, y, width, height, c, z = 0, mode = :default) ⇒ void
    draw_rect(10,10,100,100,Colors::Green)
    draw_rect(WIN_W-110,10,100,100,Colors::Red)
    draw_rect(10,WIN_H-110,100,100,Colors::Blue)
    draw_rect(WIN_W-110,WIN_H-110,100,100,Colors::Yellow)
    # image.draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
    @mouse_coords_txt_title.draw(400,0,0)
    @mouse_coords_txt.draw(400,20,0)
    i = 0
    while(i < 10)
      # draw_line(x1, y1, c1, x2, y2, c2, z = 0, mode = :default) ⇒ void
      line_y = (i*10+WIN_H/2)
      draw_line(0,line_y,Colors::Mint,WIN_W,line_y,Colors::Mint,0)
      i += 1
    end
    # draw cursor
    draw_line(@cur_mouse_x-10,@cur_mouse_y,Colors::BrightPurple,@cur_mouse_x+10,@cur_mouse_y,Colors::BrightPurple,0)
    draw_line(@cur_mouse_x,@cur_mouse_y-10,Colors::BrightPurple,@cur_mouse_x,@cur_mouse_y+10,Colors::BrightPurple,0)
  end # draw

  def update
    self.update_mouse_coords
  end # update

end # END MyWindow


# start it up
gameWindow = MyWindow.new
gameWindow.show
