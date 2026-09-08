extends Control


@onready var _score_text = $Final/ScoreLabel
var puntaje:=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("El nodo del Label es: ", _score_text)
	 # Replace with function body.

func _update_score(new_score):
	print("¡Señal recibida! El puntaje es: ", new_score)
	$Final/ScoreLabel.text = str(new_score)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
	#$Final/ScoreLabel.text = str(delta*0 + puntaje);
	#_score_text.text = "%06d" % last_score
	
