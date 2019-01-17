### Installation
# https://gameswithcode.com/installing-gosu-on-os-x/

# $ brew install sdl2 libogg libvorbis
# $ gem install gosu

### EXAMPLE basic window

# Main ref
# https://www.rubydoc.info/github/gosu/gosu/master/Gosu

class GameWindow < Gosu::Window
  # The constructor initializes the Gosu::Window base class. The parameters shown here create a 640x480 pixels large window. It also sets the caption of the window, which is displayed in its title bar.
    # You can create a fullscreen window by passing :fullscreen => true after the width and height.
  # Gosu::Image#initialize takes two arguments, the filename and an (optional) options hash. Here we set :tileable to true.
  # Basically, you should use :tileable => true for background images and map tiles.
  def initialize
    super 640, 480
    # :fullscreen => true
    self.caption = "Gosu Tutorial Game"
  end

  # update() and draw() are overrides of Gosu::Window's methods.
  def update
    # main game loop
    # update() is called 60 times per second (by default) and should contain the main game logic: move objects, handle collisions...
  end

  def draw
    # draw() is called afterwards and whenever the window needs redrawing for other reasons,
      # and may also be skipped every other time if the FPS go too low.
    # It should contain the code to redraw the whole screen, but no updates to the game's state.
  end
end

window = GameWindow.new
# Then follows the main program. We create a window and call its show() method,
  # which does not return until the window has been closed by the user or by calling close().
window.show


# Drawing primitives

.draw_line(x1, y1, c1, x2, y2, c2, z = 0, mode = :default) ⇒ void
#  Draws a line from one point to another—inconsistently.
.draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z = 0, mode = :default) ⇒ void
# Draws a quad (actually two triangles).
.draw_rect(x, y, width, height, c, z = 0, mode = :default) ⇒ void
# Draws a rectangle (actually a quad, or two triangles).
.draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3, z = 0, mode = :default) ⇒ void
# Draws a triangle.

# IMAGE
# http://www.rubydoc.info/github/gosu/gosu/Gosu/Image
draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
# Draws the image with its top left corner at (x, y).
draw_as_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z, mode = :default) ⇒ void
# Draws the image as an arbitrary quad.
draw_rot(x, y, z, angle, center_x = 0.5, center_y = 0.5, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void

# offset
# Returns the X component of a vector of angle theta and magnitude r, or the horizontal distance covered by moving r pixels in the direction given by theta.
.offset_x(theta, r) ⇒ Float
.offset_y(theta, r) ⇒ Float

# Random, Returns a random number in the range [min; max).
.random(min, max)


# TEXT
# Creates a reusable image from one or more lines of text.
.from_text(text, line_height, options = {}) ⇒ Gosu::Image
# EXAMPLE
@my_img = Gosu::Image.from_text( "mytext", 20)
