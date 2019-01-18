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

Keys_pressed = {
  'left' => false,
  'right' => false,
  'up' => false,
  'down' => false,
  'space' => false,
  'enter' => false,
  'mouse_left' => false,
  'mouse_right' => false
}


class MyWindow < Gosu::Window

  def initialize()
    super(WIN_W, WIN_H, :fullscreen => false)
    self.caption = "Disk Profiler" # the caption method must come after the window creation "super()"
    @ctx = "start"
    @mouse_coords_txt_title = Gosu::Image.from_text( "Mouse X,Y: ", 20, {:align => :center})
    @mouse_coords_txt = "nothing yet"
    @cur_mouse_x = 0;
    @cur_mouse_y = 0;
    @cur_dir_entries = Dir.entries(".")
    @cur_dir_list = self.build_dir_list_txt(".") # array of Gosu Txt Images
    @cur_dir_list_top_offset = 20;
    @cur_dir_list_left_offset = 20;
    @cur_dir_path_title = self.update_dir_path_txt()
    @hover_dir_list = false
    @cur_fps_txt = self.update_fps()
    @last_clicked_dir = nil
    @tmpfont = Gosu::Font.new(self, Gosu::default_font_name, 20)
    puts @tmpfont.name
  end

  def build_dir_list_txt(some_dir_str)
    entries = Dir.entries(some_dir_str)
    new_arr = []
    i = 0
    entries.each do |item|
      new_arr[i] = Gosu::Image.from_text( item.to_s, Globals::Master_font_size, {:align => :left})
      i += 1
    end
    return new_arr
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

  def change_dir_context(new_dir_str)
    Dir.chdir(new_dir_str)
    @cur_dir_entries = Dir.entries(".")
    @cur_dir_list = self.build_dir_list_txt(".")
    @cur_dir_path_title = self.update_dir_path_txt()
    @hover_dir_list = false
  end

  def update_fps()
    new_img = Gosu::Image.from_text( "fps = #{Gosu.fps}", 20,{:align => :right})
    return new_img
  end

  def draw_box(x,y,width,height,color)
    # draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default) ⇒ void
    draw_line(x,y,color,x+width,y,color)
    draw_line(x+width,y,color,x+width,y+height,color)
    draw_line(x+width,y+height,color,x,y+height,color)
    draw_line(x,y+height,color,x,y,color)
  end

  def get_cur_list_width
    max_width = 2
    @cur_dir_list.each do |img|
      if (img.width > max_width)
        max_width = img.width
      end
    end
    return max_width
  end

  def check_mouse_over_list() # bounding on Dir list
    list_px_length = ((@cur_dir_list.length) * Globals::Master_font_size)
    list_px_width = self.get_cur_list_width
    y_off = @cur_dir_list_top_offset
    x_off = @cur_dir_list_left_offset
    if ((@cur_mouse_x > x_off) && (@cur_mouse_x < (x_off + list_px_width))) && ((@cur_mouse_y > y_off) && (@cur_mouse_y <= (y_off + list_px_length-1)))
      @hover_dir_list = true
    else
      @hover_dir_list = false
    end
  end

  def get_list_hover_item()
    item = nil
    f_size = Globals::Master_font_size
    top_off = @cur_dir_list_top_offset
    return item
  end

  def get_list_item_hover_index()
    return ((@cur_mouse_y - @cur_dir_list_top_offset) / Globals::Master_font_size).floor
  end

  def button_down(button)
    if (button == Gosu::KbEscape)
       self.close!
    elsif (button == Gosu::KbSpace)
      puts "KbSpace"
    else
      puts button
      super
    end
  end # END BUTTON DOWN

  def left_click()
    if (@hover_dir_list == true)
      ind = self.get_list_item_hover_index()
      clicked_str = @cur_dir_entries[ind]
      puts "INPUT: File "+"\'#{clicked_str}\'"+" was left-clicked"
      if (File.directory?(clicked_str) == true)
        puts "thats a FOLDER"
        self.change_dir_context(clicked_str)
      elsif
        puts "thats a FILE"
      end
    end
  end

  def right_click()
    if (@hover_dir_list == true)
      ind = self.get_list_item_hover_index()
      clicked_str = @cur_dir_entries[ind]
      puts "INPUT: File "+"\'#{clicked_str}\'"+" was right-clicked"
      if (File.directory?(clicked_str) == true)
        puts "thats a FOLDER"
        self.change_dir_context(clicked_str)
      elsif
        puts "thats a FILE"
      end
    end
  end

  ####INPUT#######################################################
  def update_keys()

    if (Gosu.button_down?(Gosu::KB_LEFT) == true)
      if (Keys_pressed[:left] == false) # only happens 1 time on first push
        puts "KB_LEFT"
        Keys_pressed[:left] = true;
      end
    else
      Keys_pressed[:left] = false;
    end

    if (Gosu.button_down?(Gosu::KB_RIGHT) == true)
      if (Keys_pressed[:right] == false)
        puts "KB_RIGHT"
        Keys_pressed[:right] = true;
      end
    else
      Keys_pressed[:right] = false;
    end

    if (Gosu.button_down?(Gosu::KB_UP) == true)
      if (Keys_pressed[:up] == false)
        puts "KB_UP"
        Keys_pressed[:up] = true;
      end
    else
      Keys_pressed[:up] = false;
    end

    if (Gosu.button_down?(Gosu::KB_DOWN) == true)
      if (Keys_pressed[:down] == false)
        puts "KB_DOWN"
        Keys_pressed[:down] = true;
      end
    else
      Keys_pressed[:down] = false;
    end

    if (Gosu.button_down?(Gosu::MS_LEFT) == true)
      if (Keys_pressed[:mouse_left] == false)
        puts "MS_LEFT"
        Keys_pressed[:mouse_left] = true;
        self.left_click()
      end
    else
      Keys_pressed[:mouse_left] = false;
    end

    if (Gosu.button_down?(Gosu::MS_RIGHT)  == true)
      if (Keys_pressed[:mouse_right] == false)
        puts "MS_RIGHT"
        Keys_pressed[:mouse_right] = true;
        self.right_click()
      end
    else
      Keys_pressed[:mouse_right] = false;
    end

  end

  ####DRAW#######################################################
  def draw()
      # draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default) ⇒ void
      # draw_rect(x, y, width, height, c, z = 0, mode = :default) ⇒ void
      draw_rect(WIN_W-120,0,100,110,Colors::Blue)
      draw_rect(WIN_W-110,WIN_H-110,100,100,Colors::Green)
      # image.draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
      @mouse_coords_txt_title.draw(WIN_W-120,0,0,
                                   1,1,Colors::Yellow)
      @mouse_coords_txt.draw(WIN_W-120,20,0,
                             1,1,Colors::Yellow)
      # draw cursor
      draw_rect(@cur_mouse_x-11,@cur_mouse_y-1,22,3,Colors::BrightPurple,1)
      draw_rect(@cur_mouse_x-1,@cur_mouse_y-11,3,22,Colors::BrightPurple,1)
      # draw directory list
      @cur_dir_path_title.draw(0,0,0,
                               1,1,Colors::Yellow)
      list_y = @cur_dir_list_top_offset
      i = 0
      @cur_dir_list.each do |img|

        if (File.directory?(@cur_dir_entries[i]) == true)
          txt_color = Colors::Green # FOLDERS
        else
          txt_color = Colors::Yellow # FILES
        end
        img.draw(@cur_dir_list_left_offset,list_y,0,
                 1,1,txt_color)
        list_y += Globals::Master_font_size
        i += 1
      end

      # draw color boxes around dir list and highlighted item
      if (@hover_dir_list == true)
        list_px_length = ((@cur_dir_list.length) * Globals::Master_font_size)
        list_px_width = self.get_cur_list_width
        self.draw_box(@cur_dir_list_left_offset,@cur_dir_list_top_offset-1,list_px_width+1,list_px_length+1,Colors::BrightPurple) # self.draw_box(x,y,width,height,color)
        hover_item_index = self.get_list_item_hover_index()
        self.draw_rect(@cur_dir_list_left_offset,@cur_dir_list_top_offset+(hover_item_index*Globals::Master_font_size),
                      list_px_width,Globals::Master_font_size,
                      Colors::Green)
      end
      # draw FPS
      @cur_fps_txt.draw(WIN_W-120,60,0,
                        1,1,Colors::Yellow)

      # draw_text(text, x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
      # @tmpfont.draw("Hello World!", WIN_W/2, WIN_H/2, 1, 1.0, 1.0, Colors::Blue)
  end # draw

  ####UPDATE#####################################################
  def update()
      self.update_keys()
      self.update_mouse_coords()
      self.check_mouse_over_list()
      if ((Gosu.milliseconds % 100) <= 17)
        @cur_fps_txt = self.update_fps()
      end
  end # update

end # END MyWindow


# start it up
gameWindow = MyWindow.new
gameWindow.show
