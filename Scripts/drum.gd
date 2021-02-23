extends Sprite

var hitType;

func create_texture_from_path(path: String) -> ImageTexture:
	var img = Image.new()
	var itex = ImageTexture.new()
	img.load(path)
	itex.create_from_image(img)
	return itex
	
func _init(ht):
	hitType = ht
	var bluePath = "res://Sprites/grafanaLogoBlue.png"
	var redPath = "res://Sprites/grafanaLogoRed.png"
	var path = null
	match hitType:
		global.HitType.Red:
			path = redPath
		global.HitType.Blue:
			path = bluePath
	self.texture = create_texture_from_path(path)
	self.scale = Vector2(.1, .1)
