extends Area3D

var time := 0.0
var grabbed := false


# Collecting coins

func _on_body_entered(body):
	if body.has_method("collect_coin") and !grabbed:
		
		body.collect_coin()
		
		Audio.play("res://sounds/coin.ogg") # Play sound
		$Sketchfab_Scene.queue_free()
		$Particles.emitting = false # Stop emitting stars
		
		grabbed = true

# Rotating, animating up and down

func _process(delta):
	
	rotate_y(0.5 * delta) # Rotation
	position.y += (cos(time * 5) * 0.5) * delta # Sine movement
	
	time += delta
