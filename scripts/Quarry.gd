extends Node2D


signal cut_stone

export (PackedScene) var rough_block_scene

var stone_left
var total_stone = 11 * 22


# Called when the node enters the scene tree for the first time.
func _ready():
	stone_left = total_stone
	$Outline.visible = false
	


func remove_stone():
	stone_left -= 1
	
	var frame
	if stone_left == 0:
		frame = 25
	elif stone_left == total_stone:
		frame = 0
	else:
		var t = 1 - (stone_left - 1) / (float(total_stone) - 2)
		frame = (24.9 - 1.1) * t + 1.1

	$Sprite.frame = int(frame)


func get_stone_to_cut():
	var block = rough_block_scene.instance()
	block.quarry_node = self
	block.visible = false
	var x = fmod(stone_left / total_stone * 5, 1)
	var y = floor(stone_left / total_stone * 5) / 5
	block.position = ($BottomrightPoint.position - $TopleftPoint.position) * Vector2(x, y) + $TopleftPoint.position
	
	add_child(block)
	return block

func _on_MouseoverArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("cut_stone")


func _on_MouseoverArea_mouse_entered():
	$Outline.visible = true


func _on_MouseoverArea_mouse_exited():
	$Outline.visible = false


func is_stone_left():
	return (stone_left > 0)
