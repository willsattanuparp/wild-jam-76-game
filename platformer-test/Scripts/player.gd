class_name Player extends CharacterBody2D

const GRAVITY = 4000
const JUMP_FORCE = -800
const VARIABLE_JUMP_MULTIPLIER = 1.8
const MAX_SPEED = 300
const ACCELERATION = 20
const FRICTION = 20

var coyote_timer = 0.0
var coyote_time = 0.2

@export var strike_hitbox: Area2D
@export var player_sprite: Sprite2D
@export var enemy: Enemy

var can_attack: bool = true
var attack_duration = 0.3
@onready var attack_timer = attack_duration

var facing_right = true

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

func _process(delta: float) -> void:
	if !can_attack:
		if attack_timer > 0:
			attack_timer -= delta
		else:
			can_attack = true
			strike_hitbox.monitoring = false
			attack_timer = attack_duration

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
	
	#strike
	if Input.is_action_just_pressed("Attack") and can_attack:
		can_attack = false
		strike_hitbox.monitoring = true
	#special - freeze
	if Input.is_action_just_pressed("Special") and freeze_timer <= 0:
		freeze_timer = FREEZE_COOLDOWN
		special.emit()
	elif freeze_timer > 0:
		freeze_timer -= delta
	#crouch
	if Input.is_action_just_pressed("Crouch"):
		crouch()
	elif Input.is_action_just_released("Crouch"):
		uncrouch()
	#directional logic
	if velocity.x != 0:
		if velocity.x > 0 and !facing_right:
			flip_player(true)
		elif velocity.x < 0 and facing_right:
			flip_player(false)
	move_and_slide()

func crouch():
	pass

func uncrouch():
	pass

func flip_player(face_right):
	facing_right = face_right
	strike_hitbox.position.x *= -1
	player_sprite.scale.x *= -1

func damage():
	print("damaging")
	hearts -= 1
	ui_heart_damage.emit()
	if hearts <= 0:
		print("game over")
		game_over.emit()


func _on_strike_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Projectile") and area.frozen:
		area.send_back(global_position,enemy.global_position, 1200)
