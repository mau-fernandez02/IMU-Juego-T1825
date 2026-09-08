extends CharacterBody3D

@export var player: Node3D

@onready var raycast = $RayCast
@onready var muzzle_a = $MuzzleA
@onready var muzzle_b = $MuzzleB

var health := 100
var time := 0.0
var target_position: Vector3
var destroyed := false

# --- Propiedades para Movimiento en L ---
var l_path: Array[Vector3] = [] 
var path_index: int = 0
@export var move_speed: float = 4.0   
@export var l_size_x: float = 6.0   
@export var l_size_z: float = 4.0   
var floor_y: float 

# --- Señal para notificar al juego cuando es destruido ---
signal destroyed_signal 
# ----------------------------------------


func _ready():
	# 1. Guarda la altura Y inicial.
	floor_y = global_position.y
	
	# 2. Define los 4 puntos de la trayectoria 'L'
	# CLAVE: Usamos la posición LOCAL (Vector3.ZERO) como punto de partida relativo,
	#        luego la hacemos global.
	
	# Puntos relativos a la posición inicial del enemigo
	var p0 = Vector3.ZERO
	var p1 = Vector3(l_size_x, 0, 0)
	var p2 = Vector3(l_size_x, 0, l_size_z)
	var p3 = Vector3(0, 0, l_size_z)
	
	# Convierte los puntos relativos a coordenadas globales y los añade a la ruta
	l_path.append(global_position + p0)
	l_path.append(global_position + p1)
	l_path.append(global_position + p2)
	l_path.append(global_position + p3)
	
	# 3. Inicializa el target_position al primer punto (el lugar donde ya está)
	target_position = l_path[0]
	
	# 4. Asegúrate de que el cuerpo esté en el piso
	global_position.y = floor_y
	
	# 5. FUERZA el cambio al SEGUNDO punto para iniciar el movimiento inmediatamente
	#    Esto asegura que el enemigo empiece a moverse incluso si está exactamente en el primer punto.
	#    Si el enemigo estuviera en l_path[0], el path_index cambia a 1.
	path_index = 1
	target_position = l_path[path_index]


# Función auxiliar para que Main.gd pueda conectarse a la señal al iniciar el nivel
func connect_destroy_signal(target_node):
	destroyed_signal.connect(target_node.on_enemy_destroyed)

# Se usa _physics_process para el movimiento basado en colisiones
func _physics_process(delta):
	# Orienta el enemigo hacia el jugador
	self.look_at(player.global_position + Vector3(0, 0.5, 0), Vector3.UP, true)
	
	# Calcula la dirección hacia el próximo punto del camino (sólo XZ)
	var direction_xz = (target_position - global_position).normalized()
	
	# El vector de velocidad.
	velocity.x = direction_xz.x * move_speed
	velocity.z = direction_xz.z * move_speed
	velocity.y = 0.0 # Mantiene la velocidad vertical a cero
	
	# Mueve el CharacterBody3D.
	move_and_slide()
	
	# Lógica de Cambio de Punto (Chocar con Pared O Alcanzar Destino)
	if is_on_wall() or global_position.distance_to(target_position) < 0.1:
		
		# Avanza al siguiente punto del camino.
		path_index = (path_index + 1) % l_path.size()
		target_position = l_path[path_index]
		
	# Mantiene al enemigo exactamente en el piso
	global_position.y = floor_y
	
func _process(delta):
	time += delta

# Take damage from player
func damage(amount):
	# Audio.play("sounds/enemy_hurt.ogg")
	health -= amount

	if health <= 0 and !destroyed:
		destroy()

# Destroy the enemy when out of health
func destroy():
	# Audio.play("sounds/enemy_destroy.ogg")

	# 1. Notificar al controlador ANTES de eliminarse
	if !destroyed:
		destroyed_signal.emit() 
	
	destroyed = true
	queue_free()

# Shoot when timer hits 0
func _on_timer_timeout():
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()

		if collider.has_method("damage"):
			
			# Play muzzle flash animation(s)
			muzzle_a.frame = 0
			muzzle_a.play("default")
			muzzle_a.rotation_degrees.z = randf_range(-45, 45)

			muzzle_b.frame = 0
			muzzle_b.play("default")
			muzzle_b.rotation_degrees.z = randf_range(-45, 45)

			# Audio.play("sounds/enemy_attack.ogg")

			collider.damage(5)
