class_name Player extends CharacterBody2D

const GRAVITY = 4000
const JUMP_FORCE = -800
const VARIABLE_JUMP_MULTIPLIER = 1.8
const MAX_SPEED = 300
const ACCELERATION = 20
const FRICTION = 20

var coyote_timer = 0.0
var coyote_time = 0.2

const FREEZE_COOLDOWN = 4.0
var freeze_timer = 0.0

var hearts = 10
signal ui_heart_damage()
signal game_over()

signal special()
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#freeze_ripple(1)
#
#var ripple_time = 0.0
#var ripple_duration = 2.0 # Duration of the ripple effect in seconds
#var ripple_speed = 50.0
#
#func _process(delta):
	#ripple_time += delta
	#$Sprite2D.material.set_shader_parameter("time",ripple_time)

func _physics_process(delta: float) -> void:
	#Gravity effect
	if !is_on_floor():
		velocity.y += GRAVITY * delta
		#coyote_timer
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time
	#input movement
	var direction: Vector2 = Input.get_vector("Left","Right","Up","Down")
	#left/right input
	#if direction.x != 0:
		#velocity.x = lerp(velocity.x, direction.x * MAX_SPEED, ACCELERATION * delta)
	velocity.x = lerp(velocity.x, direction.x * MAX_SPEED, ACCELERATION * delta if direction.x != 0 else FRICTION * delta)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	#else:
		#velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
	#jumping
	if Input.is_action_just_pressed("Jump") and Input.is_action_pressed("Down"):
		position.y += 1
	elif Input.is_action_just_pressed("Jump") and coyote_timer > 0:#is_on_floor():
		velocity.y = JUMP_FORCE
		coyote_timer = 0
	#logic if moving upwards
	if velocity.y < 0:
		#variable jump height
		if Input.is_action_pressed("Jump"):#is_on_floor():
			velocity.y  += JUMP_FORCE * delta * VARIABLE_JUMP_MULTIPLIER
		#cancel momentum if head bumps ceiling
		if is_on_ceiling():
			velocity.y = 0
	
	if Input.is_action_just_pressed("Special") and freeze_timer <= 0:
		freeze_timer = FREEZE_COOLDOWN
		special.emit()
	elif freeze_timer > 0:
		freeze_timer -= delta
	move_and_slide()

func damage():
	hearts -= 1
	ui_heart_damage.emit()
	if hearts <= 0:
		print("game over")
		game_over.emit()
