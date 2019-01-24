

class Dir_list
  attr_accessor(:x, :y, :z,
                :file_name_list,
                :file_size_list,
                :list_spacer,
                :cur_dir_entries,
                :cur_path_img,
                :total_width,
                :total_height,
                :hover_list,
                :hover_item_index
              )

  def initialize(x,y,cur_dir)
    @x = x
    @y = y
    @z = 0
    @file_name_list = nil
    @file_size_list = nil
    @list_spacer = 20
    @title_size = 24;
    @cur_dir_entries = Dir.entries(".")
    @path_img = self.update_path_img()
    self.build_dir_list_txt(".")
    @file_name_list_width = self.get_img_list_max_width(@file_name_list)
    @file_size_list_width = self.get_img_list_max_width(@file_size_list)
    @total_width = ( @file_name_list_width + @file_size_list_width + @list_spacer )
    @total_height = ( @file_name_list.length * Master_font_size )
    @hover_list = false
    @hover_item_index = nil
    @camera_index_offset = 0
    @scroll_bar = self.build_scroll_bar()
    puts "Dir_list initialize complete"
    puts "@file_name_list.length = #{@file_name_list.length}"
  end

  def build_scroll_bar()
    # scroll_obj = {x: @x, y: @y-12, height: 100, width: 10, car_height: 20, car_width: 8, car_pos: 0 }
    bar_w = 10
    scroll_obj = {
      x: @x - bar_w - 6,
      y: @y,
      height: ( ((WIN_H-@y) < @total_height) ? WIN_H-@y : @total_height ) + 2,
      width: bar_w,
      car_height: 20,
      car_width: 8,
      car_y: (@y + (@camera_index_offset * Master_font_size) )
    }
    puts "@scroll_bar = #{scroll_obj}"
    return scroll_obj
  end

  def build_dir_list_txt(dir_str)
    name_list = []
    size_list = []
    i = 0
    Dir.entries(dir_str).each do |item|
      name_list[i] = Gosu::Image.from_text("#{item.to_s}",
                                                 Master_font_size,
                                                 {:align => :left})
      size_list[i] = Gosu::Image.from_text("(#{(File.size(item)).to_f / 1000} KB)",
                                                  Master_font_size,
                                                  {:align => :left})
      i += 1
    end
    @file_name_list = name_list
    @file_size_list = size_list
  end

  def update_path_img()
    new_txt = Gosu::Image.from_text( Dir.pwd, @title_size)
    return new_txt
  end

  def get_img_list_max_width(array_of_images)
    max_width = 2
    array_of_images.each do |img|
      if (img.width > max_width)
        max_width = img.width
      end
    end
    return max_width
  end

  def get_list_item_hover_index()
    return ((GameWindow.cur_mouse_y - @y) / Master_font_size).floor
  end

  def check_mouse_over_list() # bounding on Dir list
    list_px_length = (@file_name_list.length * Master_font_size)
    # list_px_width = self.get_cur_list_width
    y_off = @y
    x_off = @x
    if ( ((GameWindow.cur_mouse_x > x_off) && (GameWindow.cur_mouse_x < (x_off + @total_width))) &&
       ((GameWindow.cur_mouse_y > y_off) && (GameWindow.cur_mouse_y <= (y_off + list_px_length-1))) )
      @hover_list = true
    else
      @hover_list = false
    end
  end

  def change_dir_context(new_dir_str)
    Dir.chdir(new_dir_str)
    @camera_index_offset = 0
    @cur_dir_entries = Dir.entries(".")
    self.build_dir_list_txt(".")
    @path_img = self.update_path_img()
    @file_name_list_width = self.get_img_list_max_width(@file_name_list)
    @file_size_list_width = self.get_img_list_max_width(@file_size_list)
    @total_width = ( @file_name_list_width + @file_size_list_width + @list_spacer )
    @total_height = ( @file_name_list.length * Master_font_size )
    @hover_list = false
    @hover_item_index = nil
    @scroll_bar = self.build_scroll_bar()
  end

  def try_move_list_up()
    if (@camera_index_offset > 0)
      @camera_index_offset -= 1
      @scroll_bar = self.build_scroll_bar()
      puts "@camera_index_offset = #{@camera_index_offset}"
    end
  end

  def try_move_list_down()
    if (@camera_index_offset < (@file_name_list.length - 1) )
      @camera_index_offset += 1
      @scroll_bar = self.build_scroll_bar()
      puts "@camera_index_offset = #{@camera_index_offset}"
    end
  end

  def draw()
    # bracket
    # draw_line(@x,@y,Colors::Green,  @x+50,@y,Colors::Green)
    # draw_line(@x,@y,Colors::Green,  @x,@y+50,Colors::Green)
    ### directory title path
    dir_path_color = Colors::Mint
    # puts "path_img.height = #{@path_img.height}"
    @path_img.draw(@x,@y-@title_size,1,
                   1,1,dir_path_color)
    draw_box( @x-2, @y-@title_size, # draw_box(x,y,width,height,color)
              @x-2+@path_img.width+4, @y-@title_size+8, dir_path_color)
    # draw file names
    list_y = @y
    # i = 0
    i = @camera_index_offset
    (@file_name_list.length - @camera_index_offset).times do |j|
      if (File.directory?(@cur_dir_entries[i]) == true)
        txt_color = Colors::Green # FOLDERS
      else
        txt_color = Colors::Yellow # FILES
      end
      @file_name_list[i].draw(@x,list_y,0,
                              1,1,txt_color)
      list_y += Master_font_size
      i += 1
    end
    ### draw file sizes
    left_x_offset = @file_name_list_width + @list_spacer
    list_y_offset = 0
    # i = 0
    i = @camera_index_offset
    (@file_size_list.length - @camera_index_offset).times do |j|
      if (File.directory?(@cur_dir_entries[i]) == true)
        txt_color = Colors::Green # FOLDERS
      else
        txt_color = Colors::Yellow # FILES
      end
      @file_size_list[i].draw(@x + left_x_offset,@y + list_y_offset, 0,
                              1,1,txt_color)
      list_y_offset += Master_font_size
      i += 1
    end
    # draw color boxes around dir list and highlighted item
    if (@hover_list == true)
      # draw_box(@x, @y,
      #          @total_width+3, @total_height+1,
      #          Colors::BrightPurple)
      draw_rect(@x, @y+(@hover_item_index*Master_font_size),
                @total_width,Master_font_size,
                Colors::MossGreen)
    end
    # draw scroll bar
    # scroll_obj = {x: @x, y: @y-12, height: 100, width: 10, car_height: 20, car_width: 8, car_pos: 0 }
    draw_box( @scroll_bar[:x], @scroll_bar[:y],
              @scroll_bar[:width], @scroll_bar[:height], Colors::Mint )
    # scroll_bar car
    draw_box( @scroll_bar[:x] + 1, @scroll_bar[:car_y] + 1,
              @scroll_bar[:car_width], @scroll_bar[:car_height],
              Colors::Mint )
    draw_rect(@scroll_bar[:x] + 1, @scroll_bar[:car_y] + 2,
              @scroll_bar[:car_width] - 1, @scroll_bar[:car_height] - 1,
              Colors::Red )
  end # end DRAW

  def update()
    self.check_mouse_over_list();
    if (@hover_list == true)
      @hover_item_index = self.get_list_item_hover_index()
    end
  end # end UPDATE

end
