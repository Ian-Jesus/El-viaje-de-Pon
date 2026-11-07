extends Node2D
@export var tiempo:float = 2.5
signal golpe()

func iniciar(pos):
	position = Vector2(pos,500)

func _ready() -> void:
	await get_tree().create_timer(tiempo).timeout
	destruir()

func destruir():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		pass # Efecto visual de peligro

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		emit_signal("golpe")
		
