extends Node2D

class_name CutBlock


var i
var j
var destination: Vector2
var temple_node


func set_pattern(pattern):
	# starting at (1, 1):
	# o o x x
	# o o o o
	# x x o o
	# (ignoring x cells)
	# 1 means black
	var skip_pixels = [[0, 2], [0, 3], [2, 0], [2, 1]]
	var image: Image = $Sprite.texture.get_data()
	image.lock()
	for pattern_y in range(3):
		var row = pattern[pattern_y]
		for pattern_x in range(4):
			if skip_pixels.has([pattern_y, pattern_x]):
				continue
				
			image.set_pixel(pattern_x + 1, pattern_y + 1, Color(0, 0, 0, 1) if row[pattern_x] else Color(1, 1, 1, 1))
		
	image.unlock()
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	texture.set_flags(0)
	$Sprite.set_texture(texture)
