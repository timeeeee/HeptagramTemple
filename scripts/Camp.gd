extends Node2D

class_name Camp
func _ready():
	randomize()
	$AnimationPlayer.play("Burn")


# get a position for a worker to rest in
func get_rest_position():
	# get a position in circle of radius 1
	var coord
	while true:
		coord = Vector2(randf() * 2 - 1, randf() * 2 - 1)
		if coord.length_squared() < 1:
			break
			
	coord *= $RestArea/CollisionShape2D.shape.radius
	coord += $RestArea/CollisionShape2D.position
	return coord

