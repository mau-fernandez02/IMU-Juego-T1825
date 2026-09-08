extends Area3D
var coso := false;
var time := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(0.5 * delta) # Rotation
	position.y += (cos(time * 5) * 0.5) * delta # Sine movement
	
	time += delta


func _on_body_entered(body):
	if body.has_method("reduce_life") and !coso:
		
		body.reduce_life()
		
		Audio.play("res://sounds/coin.ogg") # Play sound
		$Sketchfab_Scene.queue_free()
		$Mesh.queue_free() # Make invisible
		
		
		coso = true
	
