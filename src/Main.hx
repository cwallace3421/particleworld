import hxd.BitmapData;
import h2d.Text;
import hxd.Event;
import h2d.Interactive;
import h2d.Bitmap;
import hxd.PixelFormat;
import hxd.Pixels;
import hxd.res.DefaultFont;

class Main extends hxd.App {

  static var DRAW_SIZE = 10;
  static var DRAW_COLOR : Int = 0xFFFF0000;

  var debugText: Text;
  var screenPixels : Pixels;
  var screenTexture : Bitmap;
  var interaction : Interactive;

  var dirty : Bool = false;

  override function init() {
    debugText = new Text(DefaultFont.get(), s2d);
    debugText.text = s2d.width + " - " + s2d.height;

    screenPixels = Pixels.alloc(s2d.width, s2d.height, PixelFormat.ARGB);
    this.generateScreenTexture();

    interaction = new Interactive(s2d.width, s2d.height, screenTexture);
    interaction.onClick = this.onMouseClick;
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

  private function onMouseClick(event : Event) {
    var x = hxd.Math.floor(event.relX);
    var y = hxd.Math.floor(event.relY);
    var max_x = cast(Math.min(x + DRAW_SIZE, 1000), Int);
    var max_y = cast(Math.min(y + DRAW_SIZE, 1000), Int);

    debugText.text = x + " - " + y;

    for (i in x...max_x) {
      for (j in y...max_y) {
        screenPixels.setPixel(i, j, DRAW_COLOR);
      }
    }
    dirty = true;
  }

  private function generateScreenTexture() {
    var tile = h2d.Tile.fromPixels(screenPixels);
    screenTexture = new Bitmap(tile, s2d);
  }

}