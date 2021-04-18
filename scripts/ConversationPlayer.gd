extends Control

class_name ConversationPlayer


export (float) var scroll_time = 1
export (float) var delay = 5
export (float) var end_delay = 3

var start_top_margin


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	start_top_margin = $ConversationVBox.margin_top
	
	
func add_and_scroll(node):
	node.modulate.a = 0
	$ConversationVBox.add_child(node)
	$DialogueFadeInTween.interpolate_property(node, "modulate:a", 0, 1, scroll_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DialogueFadeInTween.start()
	
	# make sure the label has the right size before getting the size!
	# yield(node, "resized")
	var top_start = $ConversationVBox.margin_top
	var top_end = top_start - (node.margin_bottom - margin_top + $ConversationVBox.get("custom_constants/separation") + 60)
	$ConversationScrollTween.interpolate_property($ConversationVBox, "margin_top", top_start, top_end, scroll_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ConversationScrollTween.start()


func play_conversation(conversation):
	# fade out game
	visible = true
	get_tree().paused = true
	$ConversationVBox.margin_top = start_top_margin
	
	for line in conversation:
		if line is String:
			var label: Label = Label.new()
			label.text = line
			label.autowrap = true
			add_and_scroll(label)
			yield(get_tree().create_timer(delay), "timeout")

		else:
			# line is array of dialogue choices
			var choices = VBoxContainer.new()
			for choice in line:
				var button = Button.new()
				button.flat = true
				button.text = choice
				choices.add_child(button)

				# todo: button actions
				pass
				
			add_and_scroll(choices)
			
			# todo: wait for selection instead
			yield(get_tree().create_timer(delay), "timeout")
			
	yield(get_tree().create_timer(end_delay), "timeout")
			
	# delete dialogue
	for child in $ConversationVBox.get_children():
		$ConversationVBox.remove_child(child)
		child.queue_free()
		
	visible = false
	get_tree().paused = false
