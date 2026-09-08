extends CharacterBody3D

@export_group("Camara")
@export_range(0.0,1.0) var _mouse_sensibilidad:=0.25

var _camera_direccion := Vector2.ZERO

@onready var _camera_pivot = %CameraPivote

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var camera_in_movement:=(event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED)
	if camera_in_movement:
		_camera_direccion = event.screen_relative * _mouse_sensibilidad

func _process_fisicas(delta: float) -> void:
	_camera_pivot.rotation.x += _camera_direccion.y * delta
	
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI/6.0, PI/3.0)
	_camera_pivot.rotation.y -= _camera_direccion.x * delta
	# Resetear la direccion de la camara cuando se mueve la camara
	_camera_direccion = Vector2.ZERO
