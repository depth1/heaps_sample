class Curve2D {
	var g:h2d.Graphics;
	var pp:Array<h2d.col.Point>; // previous points
	var uv:h2d.col.Point;

	@:isVar public var size(get, set):Float;

	inline static var DEFAULT_SIZE = 8;
	inline static var SCALE_FACTOR = 2;
	inline static var CURVE_DRAW_SIZE = 4;

	public function new(parent:h2d.Object, tile:h2d.Tile) {
		g = new h2d.Graphics(parent);
		g.tile = tile;
		g.tileWrap = true;
		g.filter = new h2d.filter.Group([new h2d.filter.DropShadow(12, 1.0, 0, 0.2, 1., 1., 1., false)]);
		g.scale(1 / SCALE_FACTOR);

		uv = new h2d.col.Point(0., 0.);
		size = DEFAULT_SIZE;
	}

	public function addPoint(x:Float, y:Float, a:Float) {
		x = x * SCALE_FACTOR;
		y = y * SCALE_FACTOR;

		// No point, create a point
		if (pp == null) {
			pp = getPerpPoints(x, y, a);
			return;
		}

		// get perpendicular point
		var p = getPerpPoints(x, y, a);

		// get distance (center point)
		var d = getDistance(pp[2].x, pp[2].y, p[2].x, p[2].y);

		if (d < CURVE_DRAW_SIZE) {
			return;
		}

		var u0 = uv.x;
		uv.x += d / ((g.tile.width / 2) * SCALE_FACTOR); // factor
		var u1 = uv.x;

		// add vertex relying at previous
		g.beginTileFill();

		// First triangle
		g.addVertex(pp[0].x, pp[0].y, 1, 1, 1, 1, u0, 0.);
		g.addVertex(pp[1].x, pp[1].y, 1, 1, 1, 1, u0, 1.);
		g.addVertex(p[1].x, p[1].y, 1, 1, 1, 1, u1, 1.);
		// Second triangle
		g.addVertex(p[1].x, p[1].y, 1, 1, 1, 1, u1, 1.);
		g.addVertex(p[0].x, p[0].y, 1, 1, 1, 1, u1, 0.);
		g.addVertex(pp[0].x, pp[0].y, 1, 1, 1, 1, u0, 0.);

		g.endFill();

		// set pp as p
		pp = p;
	}

	private inline function getPerpPoints(x:Float, y:Float, a:Float) {
		return [
			new h2d.col.Point(x + Math.cos(a + Math.PI / 2) * (size * SCALE_FACTOR / 2), y + Math.sin(a + Math.PI / 2) * (size * SCALE_FACTOR / 2)),
			new h2d.col.Point(x + Math.cos(a - Math.PI / 2) * (size * SCALE_FACTOR / 2), y + Math.sin(a - Math.PI / 2) * (size * SCALE_FACTOR / 2)),
			new h2d.col.Point(x, y)
		];
	}

	public static inline function getDistance(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	}

	function get_size() {
		return size;
	}

	function set_size(size) {
		return this.size = size;
	}
}
