extends CharacterBody2D

const GRAVITY = 9000
const JUMP_FORCE = -1900
const VARIABLE_JUMP_MULTIPLIER = 1.5
const MAX_SPEED = 800
const ACCELERATION = 20
const FRICTION = 20

var coyote_timer = 0.0
var coyote_time = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	if Input.is_action_just_pressed("Jump") and coyote_timer > 0:#is_on_floor():
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
	
	move_and_slide()
