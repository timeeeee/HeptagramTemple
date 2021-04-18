extends Node2D

class_name Temple

signal build_temple
signal temple_complete(fraction)

export (PackedScene) var cut_block_scene

var blocks_queued
var blocks_complete
var total_blocks = 11 * 22
var image


# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.visible = false
	blocks_complete = 0
	blocks_queued = 0
	image = $FloorPlan.texture.get_data()
	image.lock()
	
	
func block_to_pixel_coord(i, j):
	var x = 44 + 4 * i - 2 * j
	var y = 2 * i + j
	return Vector2(x, y)
	
	
func get_floor_job() -> Node2D:
	# return the next CutBlock to be placed. CutBlock node knows where it's going.
	# when there are none left to place return null
	if blocks_queued == total_blocks:
		return null

	var block = cut_block_scene.instance()
	add_child(block)
	block.i = blocks_queued % 11
	block.j = blocks_queued / 11
	block.z_index = block.i + block.j
	var topleft = block_to_pixel_coord(block.i, block.j)
	var pattern = [[], [], []]
	for pattern_y in range(3):
		for pattern_x in range(4):
			var pixel_color = image.get_pixel(pattern_x + topleft.x, pattern_y + topleft.y)
			var is_black = (pixel_color == Color(0, 0, 0, 1))
			pattern[pattern_y].push_back(1 if is_black else 0)
	
	block.set_pattern(pattern)
	block.position = (topleft - $FloorPlan.texture.get_size() / 2) * 4 + Vector2(-12, 10)  # HACK
	block.destination = block.get_global_position()
	block.temple_node = self
	block.visible = false
	
	blocks_queued += 1
	
	return block
	
	
func place_floor(chunk):
	# todo: update $Floor to include the CutRock chunk just added
	var old_pos = chunk.get_global_position()
	chunk.get_parent().remove_child(chunk)
	add_child(chunk)
	chunk.position = to_local(old_pos)
	
	blocks_complete += 1
	emit_signal("temple_complete", float(blocks_complete) / total_blocks)
	
	
func get_scaffold_job():
	# get the next scaffolding location to place. If none are left return null
	pass
	
	
func place_scaffold(scaffold):
	pass
	
	
func get_column_job():
	pass
	
	
func place_column(column):
	pass


func _on_MouseoverArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("build_temple")


func _on_MouseoverArea_mouse_entered():
	$Outline.visible = true


func _on_MouseoverArea_mouse_exited():
	$Outline.visible = false
