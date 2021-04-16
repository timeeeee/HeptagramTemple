extends Node2D


signal build_temple


# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.visible = false
	
	
func get_chunk():
	# return the next CutRock to be placed. CutRock node knows where it's going
	pass
	
	
func place_chunk(chunk):
	# update $Floor to include the CutRock chunk just added
	pass


func _on_MouseoverArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("build_temple")


func _on_MouseoverArea_mouse_entered():
	$Outline.visible = true


func _on_MouseoverArea_mouse_exited():
	$Outline.visible = false
