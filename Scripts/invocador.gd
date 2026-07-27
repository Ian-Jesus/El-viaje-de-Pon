extends CharacterBody2D
const enemigo = preload("uid://yyuxqkxovco7")
@onready var demorai: Timer = $demoraInvocacion

func invocar(_direccion_aleatoria):
	var e = enemigo.instantiate()
	e.iniciar(position,_direccion_aleatoria)
	get_tree().root.add_child(e)


func _on_demora_invocacion_timeout() -> void:
	var direccion_aleatoria = randf_range((PI/2)+0.5,(PI*3/2)-0.5)
	invocar(direccion_aleatoria)
	demorai.start()


func _on_inv_timeout() -> void:
	demorai.start()
