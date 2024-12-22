extends Enemy


@export var throw_marker: Marker2D

func _ready() -> void:
	MAX_SPEED = 100

func santa_throw():
	attack_throw(Vector2.ZERO,true, throw_marker.global_position)

func attack_consecutive(type: int,number_of_projectiles: int,direction: Vector2, time_between_projectiles: float, direct_at_player: bool, time_between_attacks: float, number_of_attacks: int, point: Vector2 = Vector2.ZERO):
	var projectile = instantiate_projectile_scene(consecutive_scene,consecutive_projectile_resource,point)
	for i in number_of_attacks:
		match type:
			0:
				animation_player.play("santa_throw")
			1:
				attack_burst(number_of_projectiles,point)
			2:
				attack_spiral(number_of_projectiles,time_between_projectiles,point)
			_:
				printerr("No type!")
		await get_tree().create_timer(time_between_attacks).timeout

func attack_state_phase_one(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			animation_player.play("santa_throw")
			await animation_player.animation_finished
		elif rand < 0.6:
			attack_spiral(8,.3)
		elif rand < 0.9:
			attack_burst(16)
		else:
			pass
	if health < 70:
		initial_attack_timer = 7.0
		attack_timer = initial_attack_timer
		change_attack_state(ATTACK_STATE.PHASE_TWO)

func attack_state_phase_two(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			attack_spiral(16,.2)
		if rand < 0.6:
			attack_burst(20)
		if rand < 0.9:
			attack_consecutive(0,0,Vector2.ZERO,0,true,1.2,5)
		else:
			pass
	if health < 40:
		initial_attack_timer = 7.0
		attack_timer = initial_attack_timer
		change_attack_state(ATTACK_STATE.PHASE_THREE)

func attack_state_phase_three(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			attack_spiral(24,.1)
		if rand < 0.6:
			attack_consecutive(1,8,Vector2.ZERO,0,true,.7,3)
		if rand < 0.9:
			attack_consecutive(2,16,Vector2.ZERO,.1,true,1.6,3)
		else:
			pass
	if health < 15:
		initial_attack_timer = 5.0
		attack_timer = initial_attack_timer
		change_attack_state(ATTACK_STATE.PHASE_FINAL)

func attack_state_phase_final(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			attack_spiral(30,.05)
		if rand < 0.6:
			attack_burst(30)
		if rand < 0.9:
			attack_consecutive(2,24,Vector2.ZERO,.1,true,2.4,3)
		else:
			pass
func play_jump_animation(anim_speed):
	animation_player.speed_scale = anim_speed
	animation_player.play("santa_jump")

func movement_animations(anim_speed):
	if !jumping:
		if direction.x != 0 and !(animation_player.is_playing() and (animation_player.current_animation == "santa_walk" or animation_player.current_animation == "santa_throw")):
			animation_player.speed_scale = anim_speed
			animation_player.play("santa_walk")
		elif direction.x == 0 and (animation_player.is_playing() and (animation_player.current_animation == "santa_walk" or animation_player.current_animation == "santa_throw")):
			animation_player.stop()
		if animation_player.is_playing() and animation_player.current_animation == "santa_walk":
			if velocity.x > 0:
				animation_player.speed_scale = -anim_speed
			elif velocity.x < 0:
				animation_player.speed_scale = anim_speed
