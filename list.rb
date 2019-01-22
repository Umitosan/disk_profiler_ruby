

class Dir_list
  attr_accessor(:x, :y, :z,
                :file_name_list,
                :file_size_list,
                :list_spacer,
                :cur_path_img,
                :total_width,
                :total_height,
                :hover_list,
                :cur_dir_entries
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
    @total_width = self.get_total_list_width()
    @total_height = (@file_name_list.length * Globals::Master_font_size)
    @hover_list = false
    puts "Dir_list initialize complete"
  end

  def build_dir_list_txt(dir_str)
    name_list = []
    size_list = []
    i = 0
    Dir.entries(dir_str).each do |item|
      name_list[i] = Gosu::Image.from_text("#{item.to_s}",
                                                 Globals::Master_font_size,
                                                 {:align => :left})
      size_list[i] = Gosu::Image.from_text("(#{(File.size(item)).to_f / 1000} KB)",
                                                  Globals::Master_font_size,
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

  def get_total_list_width
    found_width = 2
    @file_name_list.length.times do |i|
      line_width = ( @file_name_list[i].width + @file_size_list[i].width + @list_spacer)
      if (line_width > found_width)
        found_width = line_width
      end
    end
    return found_width
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

  def get_list_hover_item()
    item = nil
    f_size = Globals::Master_font_size
    top_off = 20
    return item
  end

  def get_list_item_hover_index()
    return ((gameWindow.cur_mouse_y - 20) / Globals::Master_font_size).floor
  end

  def draw()
    ### directory title path
    @path_img.draw(@x,@y,0,
                   1,1,Colors::Yellow)
    draw_line(@x,@y,Colors::Green,@x+40,@y,Colors::Green)
    draw_line(@x,@y,Colors::Green,@x,@y+40,Colors::Green)
    # draw file names
    list_y = @y + Globals::Master_font_size
    i = 0
    @file_name_list.each do |img|
      if (File.directory?(@cur_dir_entries[i]) == true)
        txt_color = Colors::Green # FOLDERS
      else
        txt_color = Colors::Yellow # FILES
      end
      img.draw(@x,list_y,0,
               1,1,txt_color)
      list_y += Globals::Master_font_size
      i += 1
    end
    ### draw file sizes
    left_x_offset = ( 10 + self.get_img_list_max_width(@file_name_list) + @list_spacer )
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
      list_y_offset += Globals::Master_font_size
      i += 1
    end
    # binding.pry
    # draw color boxes around dir list and highlighted item
    if (Globals::GameWindow.hover_dir_list == true)
      draw_box(@x,@y-1,@total_height+1,@total_width+1,Colors::BrightPurple) # draw_box(x,y,width,height,color)
      # hover_item_index = self.get_list_item_hover_index()
      # draw_rect(@cur_dir_list_left_offset,@cur_dir_list_top_offset+(hover_item_index*Globals::Master_font_size),
      #                @total_width,Globals::Master_font_size,
      #                Colors::Green)
    end
  end # end draw

  def update()

  end # end update

end
