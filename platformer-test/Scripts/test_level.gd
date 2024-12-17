extends Node2D

@onready var special_scene : PackedScene = load("res://Assets/Scenes/freeze_splash.tscn")
@export var player: Player
@export var special_holder_node: Node2D

var test_shake : PCamShake 
#
#func _ready() -> void:
	#test_shake = $ProCam2D.get_addons()[0]
	#test_shake.shake()```
func _on_player_special() -> void:
	var special = special_scene.instantiate()
	special.global_position = player.position
	special_holder_node.add_child(special)
	special.freeze_ripple(1)
