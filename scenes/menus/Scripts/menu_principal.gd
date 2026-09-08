extends Control



func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/niveles/main.tscn")



func _on_creditos_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/menus/scenes/Creditos.tscn")


func _on_salir_pressed() -> void:
	get_tree().quit()
