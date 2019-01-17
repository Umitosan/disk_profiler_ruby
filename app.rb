require 'rubygems'
require 'gosu'
include Gosu
require 'pry'
# require_relative 'player'

WIN_W = 1000
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

module Globals
  Master_font_size = 20
end


class MyWindow < Gosu::Window

  def initialize()
    super(WIN_W, WIN_H, :fullscreen => false)
    self.caption = "Disk Profiler" # the caption method must come after the window creation "super()"
    @ctx = "start"
    @mouse_coords_txt_title = Gosu::Image.from_text( "Mouse X,Y: ", 20, {:align => :center})
    @mouse_coords_txt = "nothing yet"
    @cur_mouse_x = 0;
    @cur_mouse_y = 0;
    @cur_dir_list = self.build_dir_list_txt(".")
    @cur_dir_path_title = self.update_dir_path_txt()
    @hover_dir_list = false
    @cur_fps_txt = self.update_fps()
  end

  def build_dir_list_txt(some_dir_str)
    entries = Dir.entries(some_dir_str)
    new_hash = {}
    i = 0
    entries.each do |item|
      new_hash[i] = Gosu::Image.from_text( item.to_s, Globals::Master_font_size, {:align => :left})
      i += 1
    end
    return new_hash
  end

  def update_mouse_coords()
    @cur_mouse_x = self.mouse_x
    @cur_mouse_y = self.mouse_y
    @mouse_coords_txt = Gosu::Image.from_text( "#{@cur_mouse_x},#{@cur_mouse_y}", 20)
  end

  def update_dir_path_txt()
    new_txt = Gosu::Image.from_text( Dir.pwd, 20)
    return new_txt
  end

  def update_fps()
    new_img = Gosu::Image.from_text( "fps = #{Gosu.fps}", 20,{:align => :right})
    return new_img
  end

  def check_mouse_over_list()
    list_len = ((@cur_dir_list.length+1) * Globals::Master_font_size)
    if ((@cur_mouse_x >= 0) && (@cur_mouse_x <= 100)) && ((@cur_mouse_x >= 0) && (@cur_mouse_x <= list_len))
      @hover_dir_list = true
    else
      @hover_dir_list = false
    end
  end

  ###########################################################
  def draw()
      # draw_rect(x, y, width, height, c, z = 0, mode = :default) ⇒ void
      draw_rect(10,10,100,100,Colors::Green)
      draw_rect(WIN_W-110,10,100,100,Colors::Red)
      draw_rect(10,WIN_H-110,100,100,Colors::Blue)
      draw_rect(WIN_W-110,WIN_H-110,100,100,Colors::Yellow)
      # image.draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
      @mouse_coords_txt_title.draw(400,0,0)
      @mouse_coords_txt.draw(400,20,0)
      # draw cursor
      draw_line(@cur_mouse_x-10,@cur_mouse_y,Colors::BrightPurple,@cur_mouse_x+10,@cur_mouse_y,Colors::BrightPurple,0)
      draw_line(@cur_mouse_x,@cur_mouse_y-10,Colors::BrightPurple,@cur_mouse_x,@cur_mouse_y+10,Colors::BrightPurple,0)
      # draw directory list
      list_y = 20
      @cur_dir_list.keys.each do |some_key|
        @cur_dir_list[some_key].draw(10,list_y,0)
        list_y += Globals::Master_font_size
      end
      if (@hover_dir_list == true)
        list_len_max_y = ((@cur_dir_list.length+1) * Globals::Master_font_size)
        # def draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z=0, mode=:default)
        draw_quad(1,20,Colors::Yellow,
                  100,20,Colors::Yellow,
                  1,list_len_max_y,Colors::Yellow,
                  100,list_len_max_y,Colors::Yellow)
      end
      # draw FPS
      @cur_fps_txt.draw(WIN_W-100,20,0)
  end # draw

  #########################################################
  def update()
      self.update_mouse_coords()
      self.check_mouse_over_list()
      if ((Gosu.milliseconds % 50) <= 17)
        @cur_fps_txt = self.update_fps()
      end
  end # update

end # END MyWindow


# start it up
gameWindow = MyWindow.new
gameWindow.show
