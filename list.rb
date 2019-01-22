

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
    @cur_dir_entries = Dir.entries(".")
    @path_img = self.update_path_img()
    self.build_dir_list_txt(".")
    @file_name_list_width = self.get_img_list_max_width(@file_name_list)
    @file_size_list_width = self.get_img_list_max_width(@file_size_list)
    @total_width = ( @file_name_list_width + @file_size_list_width + @list_spacer )
    @total_height = ( @file_name_list.length * Master_font_size )
    @hover_list = false
    @hover_item_index = nil
    puts "Dir_list initialize complete"
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
    new_txt = Gosu::Image.from_text( Dir.pwd, 20)
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
    return ((GameWindow.cur_mouse_y - @y - Master_font_size) / Master_font_size).floor
  end

  def check_mouse_over_list() # bounding on Dir list
    list_px_length = (@file_name_list.length * Master_font_size)
    # list_px_width = self.get_cur_list_width
    y_off = @y + Master_font_size
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
    @cur_dir_entries = Dir.entries(".")
    self.build_dir_list_txt(".")
    @file_name_list_width = self.get_img_list_max_width(@file_name_list)
    @file_size_list_width = self.get_img_list_max_width(@file_size_list)
    @total_width = ( @file_name_list_width + @file_size_list_width )
    @total_height = ( @file_name_list.length * Master_font_size )
    @hover_list = false
    @hover_item_index = nil
    # @cur_dir_list_width = self.get_cur_list_width()
    # @cur_dir_path_title = self.update_dir_path_txt()
  end

  def draw()
    ### directory title path
    dir_path_color = Colors::Orange
    @path_img.draw(@x,@y,0,
                   1,1,dir_path_color)
    draw_line(@x-2, @y-1, dir_path_color,
              @x-2+@path_img.width+4, @y, dir_path_color)
    draw_line(@x-2, @y-1, dir_path_color,
              @x-2, @y+20, dir_path_color)
    draw_line(@x-2, @y-1+20, dir_path_color,
              @x-2+@path_img.width+4, @y+20, dir_path_color)
    draw_line(@x-2+@path_img.width+4, @y, dir_path_color,
              @x-2+@path_img.width+4, @y+19, dir_path_color)
    # draw file names
    list_y = @y + Master_font_size
    i = 0
    @file_name_list.each do |img|
      if (File.directory?(@cur_dir_entries[i]) == true)
        txt_color = Colors::Green # FOLDERS
      else
        txt_color = Colors::Yellow # FILES
      end
      img.draw(@x,list_y,0,
               1,1,txt_color)
      list_y += Master_font_size
      i += 1
    end
    ### draw file sizes
    left_x_offset = @file_name_list_width + @list_spacer
    list_y_offset = 20
    i = 0
    @file_size_list.each do |img|
      if (File.directory?(@cur_dir_entries[i]) == true)
        txt_color = Colors::Green # FOLDERS
      else
        txt_color = Colors::Yellow # FILES
      end
      img.draw(@x + left_x_offset,@y + list_y_offset, 0,
               1,1,txt_color)
      list_y_offset += Master_font_size
      i += 1
    end
    # draw color boxes around dir list and highlighted item
    if (@hover_list == true)
      draw_box(@x, @y+Master_font_size-1 ,
               @total_width+3, @total_height+1,
               Colors::BrightPurple) # draw_box(x,y,width,height,color)
      draw_rect(@x, @y+((@hover_item_index+1)*Master_font_size),
                @total_width,Master_font_size,
                Colors::Green)
    end
  end # end draw

  def update()
    self.check_mouse_over_list();
    if (@hover_list == true)
      @hover_item_index = self.get_list_item_hover_index()
    end
  end # end update

end
