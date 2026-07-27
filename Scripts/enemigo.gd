extends CharacterBody2D
var velocidad = 300
func _ready() -> void:
	Global.pon_daño.connect(Callable(self,"_daño_pon"))
	Global.derrota.connect(Callable(self,"_derrota"))
	Global.victoria.connect(Callable(self,"_victoria"))

func _victoria():
	queue_free()

func _derrota():
	queue_free()

func iniciar(_position,_rotation):
	position = _position
	rotation = _rotation
	velocity = Vector2(0, -velocidad).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()


func _on_area_deteccion_body_entered(body: Node2D) -> void:
	Global.enemigo_destruido.emit(10)
	# Dudo un poco que sea de buena programacion destruir los dos objetos desde el script de uno... 
	body.queue_free()
	queue_free()
	
