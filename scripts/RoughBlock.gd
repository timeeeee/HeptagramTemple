extends Node2D


class_name RoughBlock


var quarry_node


# when cut from the ground, show
func cut():
	visible = true
	quarry_node.remove_stone()
