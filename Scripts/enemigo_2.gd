extends CharacterBody2D
# Los cambios de direccion los hace cuando quiere
const bala2 = preload("uid://pt5bc7kdwwm7")
@onready var dispararT: Timer = $dispararT

func _ready() -> void:
	Global.inmunidadEnemigo2.connect(Callable(self,"cambio_de_patron"))

func cambio_de_patron():
	print("cambio de direccion")
	velocity = Vector2(150,0)
	dispararT.start()

func disparo():
	var b2 = bala2.instantiate()
	b2.iniciar($Marker2D.global_position)
	get_tree().root.add_child(b2)
	
func iniciar(_position):
	position = _position
	velocity = Vector2(0,50)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()


func _on_disparar_t_timeout() -> void:
	disparo()
	dispararT.start()
