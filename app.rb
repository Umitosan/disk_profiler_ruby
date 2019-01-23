require 'rubygems'
require 'gosu'
include Gosu # so that Gosu's methods can be accessed faster
require 'pry'
require './list.rb'

WIN_W = 1000
WIN_H = 800
Master_font_size = 20

module Colors
  Black = 0xff000000
  LightBlk = 0x33000000
  Red = 0xaaff0000
  Green = 0xaa00ff00
  MossGreen = 0xaa228811
  Blue = 0xaa0000ff
  Yellow = 0xaaffff00
  Orange = 0xaaff9900
  Mint = 0xaa00ffbb
  BrightPurple = 0xbbff00ff
end

# BUILT IN COLORS
# NONE = Gosu::Color.argb(0x00_000000)
# BLACK = Gosu::Color.argb(0xff_000000)
# GRAY = Gosu::Color.argb(0xff_808080)
# WHITE = Gosu::Color.argb(0xff_ffffff)
# AQUA = Gosu::Color.argb(0xff_00ffff)
# RED = Gosu::Color.argb(0xff_ff0000)
# GREEN = Gosu::Color.argb(0xff_00ff00)
# BLUE = Gosu::Color.argb(0xff_0000ff)
# YELLOW = Gosu::Color.argb(0xff_ffff00)
# FUCHSIA = Gosu::Color.argb(0xff_ff00ff)
# CYAN = Gosu::Color.argb(0xff_00ffff)

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



def draw_box(x,y,width,height,color)
  # draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default) ⇒ void
  draw_line(x,y,color,x+width-1,y,color)
  draw_line(x+width,y,color,x+width,y+height,color)
  draw_line(x+width,y+height,color,x-1,y+height,color)
  draw_line(x,y+height,color,x,y,color)
end


class MyWindow < Gosu::Window
  attr_accessor(:cur_mouse_x, :cur_mouse_y, :hover_dir_list, :hover_item_index)

  def initialize()
    super(WIN_W, WIN_H, :fullscreen => false)
    self.caption = "Disk Profiler" # the caption method must come after the window creation "super()"
    @ctx = "start"
    @mouse_coords_txt_title = Gosu::Image.from_text( "Mouse X,Y: ", 20, {:align => :center})
    @mouse_coords_txt = "nothing yet"
    @cur_mouse_x = 0
    @cur_mouse_y = 0
    @cur_fps_txt = self.update_fps()
    @last_clicked_dir = nil
    @list = Dir_list.new(40,40,".") # initialize(x,y,cur_dir)
  end

  def update_mouse_coords()
    @cur_mouse_x = self.mouse_x
    @cur_mouse_y = self.mouse_y
    @mouse_coords_txt = Gosu::Image.from_text( "#{@cur_mouse_x},#{@cur_mouse_y}", 20)
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
    if (@list.hover_list == true)
      ind = @list.hover_item_index
      # binding.pry
      clicked_str = @list.cur_dir_entries[ind]
      puts "INPUT: File "+"\'#{clicked_str}\'"+" was left-clicked"
      if (File.directory?(clicked_str) == true)
        puts "thats a FOLDER"
        @list.change_dir_context(clicked_str)
      elsif
        puts "thats a FILE"
      end
    end
  end

  def right_click()
    # if (@hover_dir_list == true)
    #   ind = self.get_list_item_hover_index()
    #   clicked_str = @cur_dir_entries[ind]
    #   puts "INPUT: File "+"\'#{clicked_str}\'"+" was right-clicked"
    #   if (File.directory?(clicked_str) == true)
    #     puts "thats a FOLDER"
    #     self.change_dir_context(clicked_str)
    #   elsif
    #     puts "thats a FILE"
    #   end
    # end
  end

  def update_fps()
    new_img = Gosu::Image.from_text( "fps = #{Gosu.fps}", 20,{:align => :right})
    return new_img
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
      @list.draw()
      # draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default) ⇒ void
      # draw_rect(x, y, width, height, c, z = 0, mode = :default) ⇒ void
      # image.draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
      @mouse_coords_txt_title.draw(WIN_W-120,0,0,
                                   1,1,Colors::Yellow)
      @mouse_coords_txt.draw(WIN_W-120,20,0,
                             1,1,Colors::Yellow)
      # draw cursor
      draw_rect(@cur_mouse_x-11,@cur_mouse_y-1,22,3,Colors::BrightPurple,1)
      draw_rect(@cur_mouse_x-1,@cur_mouse_y-11,3,22,Colors::BrightPurple,1)
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
      @list.update()
      if ((Gosu.milliseconds % 100) <= 17)
        @cur_fps_txt = self.update_fps()
      end
  end # update

end # END MyWindow

# start it up
GameWindow = MyWindow.new
GameWindow.show
