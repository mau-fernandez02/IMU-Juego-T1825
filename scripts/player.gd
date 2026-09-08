extends CharacterBody3D

signal coin_collected
signal score_player(points)

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 8




var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = false
var jump_double = false

var coins = 0
var lives = 3
var score = 100


@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer

@onready var canvas_layer = $"../CanvasLayer"


# Getters
func set_Zero_Coins():
	
	coins = 0
	coin_collected.emit(coins,lives)

# Functions

func _physics_process(delta):

	# Handle functions

	handle_controls(delta)
	handle_gravity(delta)

	handle_effects(delta)

	# Movement

	var applied_velocity: Vector3

	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity

	velocity = applied_velocity
	move_and_slide()

	# Rotation

	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

	# Falling/respawning

	if position.y < -10:
		handle_dead()

	# Animation for scale (jumping and landing)

	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)

	# Animation when landing

	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")

	previously_floored = is_on_floor()
	
	# Life logic, died
	if lives < 1:
		handle_dead()
	

# Handle animation(s)

func handle_effects(delta):

	particles_trail.emitting = false
	sound_footsteps.stream_paused = true

	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / movement_speed / delta
		if speed_factor > 0.05:
			if animation.current_animation != "walk":
				animation.play("walk", 0.1)

			if speed_factor > 0.3:
				sound_footsteps.stream_paused = false
				sound_footsteps.pitch_scale = speed_factor

			if speed_factor > 0.75:
				particles_trail.emitting = true

		elif animation.current_animation != "idle":
			animation.play("idle", 0.1)
			
		if animation.current_animation == "walk":
			animation.speed_scale = speed_factor
		else:
			animation.speed_scale = 1.0
			
	elif animation.current_animation != "jump":
		animation.play("jump", 0.1)

# Handle movement input

func handle_controls(delta):

	# Movement

	var input := Vector3.ZERO

	# Movement 2
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis( "move_forward", "move_back")
	# Movement 1
	#input.x = Input.get_axis("move_forward", "move_back")
	#input.z = Input.get_axis( "move_right", "move_left")

	input = input.rotated(Vector3.UP, view.rotation.y).normalized()

	#if input.length() > 1:
	#	input = input.normalized()

	movement_velocity = input * movement_speed * delta

	# Jumping

	if Input.is_action_just_pressed("jump"):
		if jump_single or jump_double:
			jump()

# Handle Dead

func handle_dead():
	
	print("El personaje ha muerto")
	
	set_physics_process(false)
	self.hide()
	$Collider.set_deferred("disabled",true)
	
	await get_tree().create_timer(0.8).timeout
	self.global_position = Vector3(0,2,0)
	$Collider.set_deferred("disabled",false)
	Global.player_respawned.emit()
	set_physics_process(true)
	self.show()
	self.lives = 3
	set_Zero_Coins()
# Handle gravity

func handle_gravity(delta):

	gravity += 25 * delta

	if gravity > 0 and is_on_floor():

		jump_single = true
		gravity = 0

# Jumping

func jump():

	Audio.play("res://sounds/jump.ogg")

	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)

	if jump_single:
		jump_single = false;
		jump_double = true;
	else:
		jump_double = false;

# Collecting coins

func collect_coin():

	coins += 1

	coin_collected.emit(coins,lives)
	
# --- Añade esto a tu script de JUGADOR ---

func reduce_life():
	print("¡Auch! Me ha golpeado la moneda mala.")
	lives -= 1
	coin_collected.emit(coins,lives)
	# Aquí es donde pondrás tu lógica para bajar la vida.
	# Por ejemplo:
	# vida -= 1
	# if vida <= 0:
	#     print("He muerto.")
func handle_win():
	
	score = coins * 150 - (lives-3) * 100
	print(score)
	emit_signal("score_player",score)
	
	Global.player_win.emit()
	canvas_layer._finish_level()
	
	
	
