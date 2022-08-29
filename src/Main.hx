import hl.Format.PixelFormat;
import h2d.Tile;
import h2d.Graphics;
import h3d.mat.Texture;
import format.tar.Data;
import hxd.BitmapData;
import h2d.Text;
import hxd.Event;
import h2d.Interactive;
import h2d.Bitmap;
import hxd.PixelFormat;
import hxd.Pixels;
import hxd.res.DefaultFont;

class Main extends hxd.App {

  static var DRAW_SIZE = 4;
  static var DRAW_COLOR : Int = 0xFFFF0000;
  static var BACKGROUND_COLOR : Int = 0xFF000000;

  var debugText: Text;
  var screenPixels : Pixels;
  var screenTile : Tile;
  var screenTexture : Bitmap;
  var interaction : Interactive;
  // var tex : Texture;

  var mouseDown : Bool = false;

  var dirty : Bool = false;

  override function init() {
    debugText = new Text(DefaultFont.get(), s2d);
    debugText.text = s2d.width + " - " + s2d.height;

    screenPixels = Pixels.alloc(1024, 1024, PixelFormat.ARGB);
    screenTile = Tile.fromPixels(screenPixels);
    screenTexture = new Bitmap(screenTile, s2d);

    interaction = new Interactive(s2d.width, s2d.height, s2d);
    interaction.onPush = this.onMousePush;
    interaction.onRelease = this.onMouseRelease;
    interaction.onMove = this.onMouseMove;
  }

  override function update(dt : Float) {
    if (dirty) {
      this.generateScreenTexture();
      dirty = false;
    }
  }

  static function main() {
    new Main();
  }

  private function onMouseMove(event : Event) {
    if (mouseDown) {
      var min_x = cast(Math.max(event.relX - DRAW_SIZE, 0), Int);
      var min_y = cast(Math.max(event.relY - DRAW_SIZE, 0), Int);
      var max_x = cast(Math.min(event.relX + DRAW_SIZE, 1000), Int);
      var max_y = cast(Math.min(event.relY + DRAW_SIZE, 1000), Int);

      debugText.text = min_x + " - " + min_y;

      for (i in min_x...max_x) {
        for (j in min_y...max_y) {
          screenPixels.setPixel(i, j, DRAW_COLOR);
        }
      }
      dirty = true;
    }
  }

  private function onMousePush(event : Event) {
    mouseDown = true;
  }

  private function onMouseRelease(event : Event) {
    mouseDown = false;
  }

  private function generateScreenTexture() {
    if (screenTexture != null) {
      screenTexture.tile.getTexture().clear(BACKGROUND_COLOR);
      screenTexture.tile.getTexture().uploadPixels(screenPixels);
    }
  }

}