extends Node2D

@onready var special_scene : PackedScene = load("res://Assets/Scenes/freeze_splash.tscn")

var test_shake : PCamShake 
#
#func _ready() -> void:
	#test_shake = $ProCam2D.get_addons()[0]
	#test_shake.shake()

#func _process(delta: float) -> void:
	#print(test_shake.is_shaking())


func _on_player_special() -> void:
	var special = special_scene.instantiate()
	special.global_position = $Player.position
	$SpecialHolder.add_child(special)
	special.freeze_ripple(1)
