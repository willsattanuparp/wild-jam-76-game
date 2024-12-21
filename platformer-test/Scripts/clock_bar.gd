extends Node2D

@export var top_left: Sprite2D
@export var top_right: Sprite2D
@export var bot_left: Sprite2D
@export var bot_right: Sprite2D

func update_clock_ui(value):
	if value > 4 or value < 0: 
		return
	match value:
		4:
			top_right.show()
			bot_right.show()
			bot_left.show()
			top_left.show()
		3:
			top_right.hide()
			bot_right.show()
			bot_left.show()
			top_left.show()
		2:
			top_right.hide()
			bot_right.hide()
			bot_left.show()
			top_left.show()
		1:
			top_right.hide()
			bot_right.hide()
			bot_left.hide()
			top_left.show()
		0:
			top_right.hide()
			bot_right.hide()
			bot_left.hide()
			top_left.hide()
