extends Control


export (float) var message_time = 4
export (float) var fade_time = 2


func _ready():
	$MessageLabel.text = ""


func update_workers(n):
	$ResourcesHBox/WorkersLabel.text = "Workers: " + str(n)
	
	
func update_stone(n):
	$ResourcesHBox/StoneLabel.text = "Stone: " + str(n)
	
	
func update_wood(n):
	$ResourcesHBox/WoodLabel.text = "Wood: " + str(n)


func show_message(message):
	$MessageFadeoutTween.stop_all()
	$MessageLabel.text = message
	$MessageLabel.modulate.a = 1
	$MessageFadeoutTween.interpolate_property($MessageLabel, "modulate:a", 1, 0, fade_time, Tween.TRANS_LINEAR)
	yield(get_tree().create_timer(message_time), "timeout")
	$MessageFadeoutTween.start()
