extends Node2D


signal cut_tree


export (PackedScene) var tree_scene
export (int) var starting_trees = 40

var trees: Array


# choose a random point in $SpawnArea
func random_point():
	var toplefts = []
	var bottomrights = []
	var areas = []
	var total_area = 0
	for collision_shape in $SpawnArea.get_children():
		# these are all definitely rectangles
		var shape: RectangleShape2D = collision_shape.shape
		toplefts.push_back(collision_shape.position - shape.extents)
		bottomrights.push_back(collision_shape.position + shape.extents)
		var area = shape.extents.x * shape.extents.y
		total_area += area
		areas.push_back(area)
		total_area += shape.extents.x * shape.extents.y
		
	# which rectangle to use?
	var index = 0
	var r = randf() * total_area
	while r < areas[index]:
		r += areas[index]
		index += 1
		
	var position = Vector2(randf(), randf())
	return position * (bottomrights[index] - toplefts[index]) + toplefts[index]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.visible = false
	
	randomize()
	for x in range(starting_trees):
		var tree: Node2D = tree_scene.instance()
		$YSortTrees.add_child(tree)
		tree.position = random_point()
		trees.push_back(tree)
		
		
func get_tree_to_cut():
	return trees.pop_back()


func _on_MouseOverArea_mouse_entered():
	$Outline.visible = true


func _on_MouseOverArea_mouse_exited():
	$Outline.visible = false


func _on_MouseOverArea_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("cut_tree")
