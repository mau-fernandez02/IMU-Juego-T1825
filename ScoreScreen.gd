# ScoreScreen.gd (Adjunto al nodo CanvasLayer)
extends CanvasLayer

@onready var score_label = $Label # Asegúrate de que el nombre de tu Label sea 'Label'

func _ready():
	# Configuración inicial del Label (puedes ajustarla en el editor)
	if is_instance_valid(score_label):
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

# Función llamada desde Main.gd para mostrar el puntaje
func set_score(final_score: int):
	if is_instance_valid(score_label):
		score_label.text = """
		
		¡NIVEL COMPLETADO!
		
		Puntuación Final: {score}
		
		""".format({"score": final_score})
