extends Node2D

class_name Worker

signal arrived

export (float) var walk_speed = 40
export (float) var move_speed = 20

enum State {IDLE, WORKING, WALKING, PUSHING, PULLING}
var target  # vector2 or null
var state  # what are we doing
var carrying: Node2D

var workshop_node: Node2D
var camp_node: Camp
var game: Node


# what changes the state?
# if the worker is idle: the world does by calling "assign_whatever"
# if the worker is working: the assign_whatever function waits for "finished_task" signal


func _ready():
	state = State.IDLE
	target = null
	carrying = null
	
	
func _process(delta):
	# we might be:
	# - resting at the camp
	# - walking somewhere
	# - pushing stone
	# - draggin a log
	# - "working" (cutting tree/stone, building)
	# do one frame of the current task
	
	#HACK just in case
	if position == target:
		emit_signal("arrived")
	
	match state:
		State.IDLE:
			# todo: make worker fidget
			$AnimationPlayer.play("Idle")
			
		State.WORKING:
			$AnimationPlayer.play("Work")
			
		State.WALKING:
			$AnimationPlayer.play("Walk")
			var to_target = target - position
			var movement = to_target.normalized() * walk_speed * delta
			position += movement
			
			# did we get to the target?
			if to_target.length_squared() < movement.length_squared():
				position = target
				emit_signal("arrived")
			
		State.PUSHING:
			$AnimationPlayer.play("Push")
			# todo: make jerky
			var to_target = target - position
			var movement = to_target.normalized() * move_speed * delta
			position += movement
			
			# did we get to the target?
			if to_target.length_squared() < movement.length_squared():
				position = target
				emit_signal("arrived")
			
		State.PULLING:
			$AnimationPlayer.play("Pull")
			# todo: make jerky
			var to_target = target - position
			var movement = to_target.normalized() * move_speed * delta
			position += movement
			
			# did we get to the target?
			if to_target.length_squared() < movement.length_squared():
				position = target
				emit_signal("arrived")


func assign_chop(tree):
	# go to the tree
	state = State.WALKING
	target = get_parent().to_local(tree.get_global_position())
	# todo: direction
	yield(self, "arrived")
	
	# chop tree
	# todo: play sound
	state = State.WORKING
	$WorkTimer.start()
	yield($WorkTimer, "timeout")
	
	
	# take wood to workshop
	state = State.PULLING
	tree.cut()
	tree.get_parent().remove_child(tree)
	add_child(tree)
	tree.position = Vector2(-12, 4)
	# todo: direction
	target = get_parent().to_local(workshop_node.get_global_position())
	yield(self, "arrived")
	remove_child(tree)
	tree.queue_free()
	game.add_wood()
	
	# go back to camp
	state = State.WALKING
	game.queue_worker(self)
	target = camp_node.get_rest_position()
	state = State.WALKING
	
	
func assign_quarry(stone: Node2D):
	# go to the stone
	state = State.WALKING
	# todo: better distribution in quarry
	# target = get_parent().to_local(stone.get_global_position())
	target = get_parent().to_local(stone.quarry_node.get_global_position())
	var rand = Vector2(randf() * 2 - 1, randf() * 2 - 1)
	target += rand * 60
	# todo: direction
	yield(self, "arrived")
	
	# cut stone
	# todo: play sound
	state = State.WORKING
	$WorkTimer.start()
	yield($WorkTimer, "timeout")
	stone.cut()
	
	# take stone to workshop
	state = State.PUSHING
	stone.get_parent().remove_child(stone)
	add_child(stone)
	stone.position = Vector2(15, 10)
	target = get_parent().to_local(workshop_node.get_global_position())
	yield(self, "arrived")
	remove_child(stone)
	stone.queue_free()
	game.add_stone()
	
	# go back to camp
	game.queue_worker(self)
	target = camp_node.get_rest_position()
	state = State.WALKING
	

func assign_build_floor(block: Node2D):
	# get it from the workshop
	$AnimationPlayer.play("Walk")
	state = State.WALKING
	target = get_parent().to_local(workshop_node.get_global_position())
	print("worker ", self, " is going to the workshop")
	yield(self, "arrived")
	print("worker ", self, " arrived at the workshop")
	
	# take the materials to the site
	state = State.PUSHING
	block.visible = true
	block.get_parent().remove_child(block)
	add_child(block)
	block.position = Vector2(12, 4)
	target = get_parent().to_local(block.destination)
	yield(self, "arrived")
	
	# attach to the temple
	state = State.WORKING
	$WorkTimer.start()
	yield($WorkTimer, "timeout")
	block.temple_node.place_floor(block)  # takes care of parenting
	
	# go back to campsite
	
	game.queue_worker(self)
	target = camp_node.get_rest_position()
	state = State.WALKING
	
	
func assign_build_scaffold(destination: Vector2):
	pass
	
	
func assign_build_column(location: Vector2):
	# go to workshop. push stone to location. climb??? build for a moment. add
	# self to worker queue. go back to camp.
	pass
