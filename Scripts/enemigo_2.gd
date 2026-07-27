extends CharacterBody2D
# Los cambios de direccion los hace cuando quiere
func _ready() -> void:
	Global.inmunidadEnemigo2.connect(Callable(self,"cambio_de_patron"))

func cambio_de_patron():
	print("cambio de direccion")
	velocity = Vector2(0,150)

func iniciar(_position):
	position = _position
	velocity = Vector2(0,50)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
