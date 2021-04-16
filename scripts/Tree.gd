extends Node2D


func _ready():
	# we see the tree not the log
	$Standing.visible = true
	$Log.visible = false
	
	# choose a random tree and orientation
	randomize()
	$Standing.frame = randi() % 2
	$Standing.flip_h = bool(randi() % 2)
	
	
func cut():
	# now it's on the ground
	$Standing.visible = false
	$Log.visible = true
