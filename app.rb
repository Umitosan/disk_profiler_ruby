require 'rubygems'
require 'gosu'
require 'pry'
# require_relative 'player'
include Gosu

WINDOW_WIDTH = 768
WINDOW_HEIGHT = 768


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
    super(WINDOW_WIDTH, WINDOW_HEIGHT, :fullscreen => false)
    self.caption = "Disk Profiler" # the caption method must come after the window creation "super()"
    # @welcome = MyImg::Welcome
    @ctx = "start"
  end

  def draw

  end # draw

  def update

  end # update

end # END MyWindow


gameWindow = MyWindow.new
gameWindow.show
