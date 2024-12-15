extends Sprite2D

var hearts: Array
@onready var heart_number = 10
@export var heart_holder: Node2D

func _ready() -> void:
	hearts = heart_holder.get_children()

func take_damage():
	if heart_number == 0:
		printerr("hearts are already at zero")
		return
	if heart_number % 2 == 0:
		hearts[(heart_number/2) - 1].update_heart(0)
	else:
		hearts[(heart_number/2)].update_heart(-1)
	heart_number -= 1
