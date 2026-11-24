extends CharacterBody2D
@export var tiempo:float = 2.0

func iniciar(pos):
	position = Vector2(pos,500)

func _ready() -> void:
	Global.derrota.connect(Callable(self,"destruir"))
	await get_tree().create_timer(tiempo).timeout
	destruir()

func destruir():
	queue_free()
