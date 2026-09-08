# Main.gd (Adjunto al nodo Main)
extends Node3D

@onready var enemies_node = $Enemies # El nodo que contiene todos los enemigos
@onready var player_node = $Player   # El nodo Jugador

var total_enemies: int = 0
var enemies_killed: int = 0
var game_finished: bool = false
var score: int = 0

# Carga la escena de la pantalla de puntuación que crearemos en el paso 3.
# AJUSTA LA RUTA si tu pantalla está en otro lugar.
const SCORE_SCREEN = preload("res://ScoreScreen.tscn") 

func _ready():
	# 1. Contar el número inicial de enemigos
	total_enemies = enemies_node.get_child_count()
	
	# 2. Conectar la señal de 'destroy' de cada enemigo
	for enemy in enemies_node.get_children():
		# Verificar si es realmente un enemigo con el método necesario
		if enemy is CharacterBody3D and enemy.has_method("connect_destroy_signal"): 
			enemy.connect_destroy_signal(self) 
			
	print("Nivel Iniciado. Enemigos a destruir: ", total_enemies)

# Función llamada por cada enemigo a través de la señal 'destroyed_signal'
func on_enemy_destroyed():
	if game_finished:
		return
		
	enemies_killed += 1
	print("Enemigo destruido. Total matados: ", enemies_killed)
	
	if enemies_killed >= total_enemies:
		finish_level()

# Calcula y muestra la puntuación final
func finish_level():
	if game_finished:
		return
		
	game_finished = true
	
	# --- CÁLCULO DE PUNTUACIÓN ---
	# 1. Puntuación por Muertes (Muertes * 100)
	var kill_score = enemies_killed * 100
	
	# 2. Puntuación por Vida Restante
	# La vida del jugador está en 'player_node.health'
	var final_health = player_node.health
	
	score = kill_score + final_health
	# -----------------------------
	
	print("!!! NIVEL COMPLETADO !!!")
	print("Puntuación Total: ", score)
	
	# Mostrar la pantalla de puntuación
	var score_screen = SCORE_SCREEN.instantiate()
	get_tree().root.add_child(score_screen)
	
	# Pasar el puntaje total a la pantalla
	score_screen.set_score(score) 
	
	# Desactivar controles y bloquear el ratón
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player_node.set_process(false) 
	player_node.set_physics_process(false)
