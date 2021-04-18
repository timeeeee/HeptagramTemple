extends Node


export (int) var num_workers
export (NodePath) var temple
export (NodePath) var forest
export (NodePath) var quarry
export (NodePath) var camp
export(NodePath) var workshop

export (PackedScene) var worker_scene

var temple_node: Node2D
var forest_node: Node2D
var quarry_node: Node2D
var camp_node: Node2D
var workshop_node: Node2D

var wood: int
var stone: int
var available_workers: Array

var day: int

var conversation_path = "res://conversations.json"
var conversations: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	wood = 0
	stone = 0
	
	day = 1
	$ChaosAudio.volume_db = -49
	$WhiteNoise.volume_db = -50

	
	temple_node = get_node(temple)
	forest_node = get_node(forest)
	quarry_node = get_node(quarry)
	camp_node = get_node(camp)
	workshop_node = get_node(workshop)
	
	# create workers
	available_workers = []
	for x in range(num_workers):
		var worker = worker_scene.instance()
		$Camp.add_child(worker)
		worker.position = camp_node.get_rest_position()
		worker.workshop_node = workshop_node
		worker.camp_node = camp_node
		worker.game = self
		queue_worker(worker)
		
	var f = File.new()
	f.open(conversation_path, File.READ)
	conversations = JSON.parse(f.get_as_text()).result
	f.close()
	
	$GUI.show_message("Send workers to the quarry. Don't mind the trees.")


func queue_worker(worker):
	available_workers.push_back(worker)
	$GUI.update_workers(available_workers.size())
	
	
func get_worker():
	var worker = available_workers.pop_front()
	$GUI.update_workers(available_workers.size())
	return worker
	
	
func add_wood():
	wood += 1
	$GUI.update_wood(wood)
	
	
func add_stone():
	stone += 1
	$GUI.update_stone(stone)
	
	
func use_wood():
	wood -= 1
	$GUI.update_wood(wood)
	
	
func use_stone():
	stone -= 1
	$GUI.update_stone(stone)
	
	
func next_day():
	yield($CanvasLayer/ConversationPlayer.play_conversation(conversations[day - 1]), "completed")
	$ChaosAudio.volume_db += 7
	
	if day == 7:
		end_the_world()
		
	day += 1
	
	
func end_the_world():
	# todo
	print("world ended")
	$WorldOverRect.visible = true
	$WhiteNoise.volume_db = 0
	$BackgroundAudio.volume_db = -50
	

func _on_Temple_temple_complete(fraction):
	print("temple is ", fraction, " done")
	# todo: trigger end of day :-/
	if fraction >= day / float(7):
		next_day()


func _on_Quarry_cut_stone():
	# are there still trees in the forest?
	if not quarry_node.is_stone_left():
		$GUI.show_message("You are done with the quarry.")
		return
		
	if len(available_workers) < 1:
		$GUI.show_message("No workers available to work in the quarry")
		return
		
	# otherwise assign this to a worker:
	var worker = get_worker()
	var stone = quarry_node.get_stone_to_cut()
	
	yield(worker.assign_quarry(stone), "completed")


func _on_Temple_build_temple():
	# todo: if the floor is done, build scaffolding or columns
	
	if len(available_workers) < 1:
		$GUI.show_message("No workers available to build the temple")
		return
		
	if stone == 0:
		$GUI.show_message("No stone to build with! Cut some from the quarry")
		return
		
	var block = temple_node.get_floor_job()
	var worker = get_worker()
	use_stone()
	worker.assign_build_floor(block)


# player asked for a tree to get cut
func _on_Forest_cut_tree():
	# are there still trees in the forest?
	if not forest_node.are_trees_left():
		$GUI.show_message("You have cut all the trees.")
		return
		
	if len(available_workers) < 1:
		$GUI.show_message("No workers available to chop trees")
		return
		
	# otherwise assign this to a worker:
	var worker = get_worker()
	var tree = forest_node.get_tree_to_cut()
	worker.assign_chop(tree)
