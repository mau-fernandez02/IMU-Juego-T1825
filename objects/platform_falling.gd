extends Node3D

var posicion_inicial: Vector3

var falling := false
var fall_velocity := 0.0


@onready var collision_shape = $Area3D/CollisionShape3D



func _physics_process(delta):
	scale = scale.lerp(Vector3(1, 1, 1), delta * 10) # Animate scale
	
	if falling:
		fall_velocity += 15.0 * delta
		position.y -= fall_velocity * delta
	
	
	if position.y < -10 and self.visible:
		self.visible = false
		collision_shape.disabled = true # Remove platform if below threshold

func _on_body_entered(_body):
	if !falling:
		Audio.play("res://sounds/fall.ogg") # Play sound
		scale = Vector3(1.25, 1, 1.25) # Animate scale
		
	falling = true
	
func _ready():
	# 1. Guardamos la posición donde se creó la plataforma.
	posicion_inicial = self.global_position

	Global.player_respawned.connect(reiniciar)
	
func reiniciar():
	print("Reiniciando plataforma a su posición original.")
	# Reseteamos todas sus variables.
	falling = false
	fall_velocity = 0.0
	self.global_position = posicion_inicial
	# Y la volvemos a hacer visible y funcional.
	self.visible = true
	collision_shape.disabled = false
