extends CanvasLayer

@onready var mensaje_bienvenida = $Bienvenida
@onready var hud = $HUD
@onready var comenzar = $Bienvenida/Button
@onready var score = $Score
@onready var puntaje_screen = $PuntuacionScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mensaje_bienvenida.show()
	hud.hide()
	puntaje_screen.hide()
	
	get_tree().paused = true
	get_node("Bienvenida").process_mode = Node.PROCESS_MODE_ALWAYS
	pass


func _on_button_pressed() -> void:
	mensaje_bienvenida.hide()
	hud.show()
	get_tree().paused = false
	pass # Replace with function body.

func _finish_level() ->void :
	hud.hide()
	mensaje_bienvenida.hide()
	puntaje_screen.show()
	pass


# --- NUEVO: La función que realmente cambia de nivel ---
func change_level():
	# Es una buena práctica asegurarse de que el juego no esté pausado antes de cambiar de escena.
	get_tree().paused = false
	
	# Cambiamos a la escena definida en 'next_level_path'
	var error = get_tree().change_scene_to_file("res://scenes/niveles/level2.tscn")
	
	# Opcional pero recomendado: Verificar si la ruta era válida
	if error!=OK:
		push_error("No se pudo cambiar la escena. ¿La ruta es correcta? Ruta: " + "next_level_path")




func _oo_button_pressed_change_level() -> void:
	change_level()
	pass # Replace with function body.
