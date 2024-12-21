extends Enemy


@export var throw_marker: Marker2D

func _ready() -> void:
	MAX_SPEED = 100

func tree_throw():
	pass

func play_jump_animation(anim_speed):
	animation_player.speed_scale = anim_speed
	animation_player.play("tree_jump")

func movement_animations(anim_speed):
	if !jumping:
		if direction.x != 0 and !(animation_player.is_playing() and animation_player.current_animation == "tree_walk"):
			animation_player.speed_scale = anim_speed
			animation_player.play("tree_walk")
		elif direction.x == 0 and (animation_player.is_playing() and animation_player.current_animation == "tree_walk"):
			animation_player.stop()
		if animation_player.is_playing() and animation_player.current_animation == "tree_walk":
			if velocity.x > 0:
				animation_player.speed_scale = -anim_speed
			elif velocity.x < 0:
				animation_player.speed_scale = anim_speed



##attack state methods
#func attack_state_idle(delta):
	#pass
#
#func attack_state_phase_one(delta):
	#pass
#
#func attack_state_phase_two(delta):
	#pass
#
#func attack_state_phase_three(delta):
	#pass
#
##movement state methods
#func movement_state_idle(delta):
	#pass
#
#func movement_state_pacing(delta):
	#pass
#
#func movement_state_change_position(delta):
	#pass
