extends CharacterBody2D
# Los cambios de direccion los hace cuando quiere
const bala2 = preload("uid://pt5bc7kdwwm7")
@onready var dispararT: Timer = $dispararT
@onready var areaDeteccion: Area2D = $areaDeteccion
var contar:int = 1
var oneshot:bool=true
var vidaEnemiga = 5

func _ready() -> void:
	Global.derrota.connect(Callable(self, "destruir"))
	Global.victoria.connect(Callable(self, "destruir"))

func cambio_de_patron():
	velocity = Vector2(150,0)
	areaDeteccion.set_collision_mask_value(1,true) # para detectar la colision con la bala
	dispararT.start()

func disparo():
	var b2 = bala2.instantiate()
	b2.iniciar($Marker2D.global_position)
	get_tree().root.add_child(b2)
	
func iniciar(_position):
	position = _position
	velocity = Vector2(0,100)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func _on_disparar_t_timeout() -> void:
	disparo()
	dispararT.start()

func destruir():
	queue_free()

func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if contar < vidaEnemiga:
		contar += 1
		body.queue_free()
# Dudo un poco que sea de buena programacion destruir los dos objetos desde el script de uno... 
	elif contar == vidaEnemiga:
		if body.has_method("destruir"):
			body.destruir()
		Global.enemigo_destruido.emit(50)
		destruir()

func _on_area_deteccion_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("inmune") and oneshot:
		oneshot=false
		cambio_de_patron()
