class Main extends SampleApp {
	var curve:Curve2D;

	var x:Float;
	var y:Float;
	var angle:Float;
	var speed:Float;

	public function new() {
		super();
		x = 0;
		y = 10;
		angle = 0;
		speed = 20;
	}

	override function init() {
		super.init();

		var skin = hxd.Res.skin.toTile();
		curve = new Curve2D(s2d, skin);

		addText("Demo");
		addSlider("Size", function() {
			return curve.size;
		}, function(s:Float) {
			curve.size = s;
		}, 1., 1000.);

		addSlider("Angle (rad)", function() {
			return angle;
		}, function(a:Float) {
			angle = a;
		}, -10., 10.);

		addSlider("Speed", function() {
			return speed;
		}, function(s:Float) {
			speed = s;
		}, 0., 1000.);
	}

	static function main() {
		// initialize embeded ressources
		hxd.Res.initEmbed();

		new Main();
	}

	override function update(dt:Float) {
		super.update(dt);

		var dx = Math.cos(angle);
		var dy = Math.sin(angle);
		var vx = dx * dt;
		var vy = dy * dt;

		x += vx * speed;
		y += vy * speed;

		curve.addPoint(x, y, angle);
	}
}
