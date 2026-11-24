extends Area2D
const bala2 = preload("uid://pt5bc7kdwwm7")
@onready var marker_2d: Marker2D = $Marker2D

func iniciar():
	position = Vector2(60, 140)  # offset relativo a DrMedusa, ajustalo a tu gusto

func destruir():
	queue_free()

func disparo():
	var pos = marker_2d.global_position
	#var direccion_aleatoria = randf_range((PI/2)+0.5,(PI*3/2)-0.5)
	var b2 = bala2.instantiate()
	b2.iniciar(pos,(PI/2)+0.5)
	get_tree().root.add_child(b2)
	var b3 = bala2.instantiate()
	b3.iniciar(pos ,(PI*3/2)-0.5)
	get_tree().root.add_child(b3)
	

func _on_body_entered(body: Node2D) -> void:
	if body == get_parent():
		return
	if body.has_method("destruir"):
		body.destruir()
	disparo.call_deferred()
