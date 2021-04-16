extends Node2D

export (float) var woodcut_time = 2
export (float) var quarry_time = 2
export (float) var build_time = 2

var target: Vector2

signal finished_task

# what changes the state?
# if the worker is idle: the camp/world does.
# if the worker is working: the 


func _ready():
	pass
	
	
func walk_to(location: Vector2):
	pass


func assign_chop(tree):
	# go to location. chop the tree. take the wood to
	# workshop. add self to queue. go back to the camp.
	# go to the tree
	$AnimationPlayer.play("Walk")
	
	
	
func assign_quarry(location: Vector2):
	# go to location. cut stone. take stone to workshop. add self to worker
	# queue. go back to camp.
	pass
	
	
func assign_build_floor(location: Vector2, stone_node):
	# go to workshop. push stone_node to location. build for a moment. add self
	# to worker queue. go back to camp.
	pass
	
	
func assign_build_scaffold(location: Vector2):
	# go to workshop. drag log to location. build for a moment. add self to
	# worker queue. go back to camp
	pass
	
	
func assign_build_column(location: Vector2):
	# go to workshop. push stone to location. climb??? build for a moment. add
	# self to worker queue. go back to camp.
	pass
	
	
func _process(delta):
	# we might be:
	# - waiting
	# - walking somewhere
	# - pushing stone
	# - draggin a log
	# - "working" (cutting tree/stone, building)
	pass
