extends Area3D

var win_state : bool = false 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node3D) -> void:
	if body.has_method("handle_win") == true:
		body.handle_win()
		win_state = true
		Global.fin_juego = true
		
	
	
