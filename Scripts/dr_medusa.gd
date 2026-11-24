extends CharacterBody2D
# Por algun motivo no vuelve a Nexo, la idea es que se quede ahí hasta el siguiente timeout
# Orden: Nexo -> (se activa timeout) -> Llama a la accion -> Nexo -> (se activa timeout) -> Llama a la accion -> ...


# Idea: puedo hacer ataques predeterminados y de ahi que vaya eligiendo que ataque usar
# Ataque 1) golpe con tentaculo: Dr medusa se muestra por un segundo o dos y luego ataca en esa misma direccion (podria ser fuego tambien del cohete).
# Ataque 2) lluvia de bombas: tira 3 o 4 bombas al mismo tiempo, caen todas a la par dejando un espacio en medio para pasar, se muestra en el medio y rie malevolamente antes de atacar.
# Ataque 3) paraguas escudo: aparece y usa un paraguas para reflejar el ataque de pon, lo transforma en dos ataques.
# Dr Medusa sera implementado como maquina de estados
#region Variables

var minTiempo = 7.0
var maxTiempo = 8.0
var velocidadBase: float = 333.3
# Puedo ver temas de velocidad para ver que tan aleatorio aparece, o directamente crearlo en una posicion aleatoria.
@onready var timerAtaque: Timer = $dispararT
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var contar:int = 1
var vida = 10
# Actores guardados
const ADVERTENCIA = preload("uid://dyd2pe77q3m21")
const TENTACULO = preload("uid://c3yapkk2aa71y")
const BOMBA = preload("uid://c8aqt8ixb7whn")
const PARAGUAS = preload("uid://dp2xyr8csgs1")

enum estadoM {
	nexo,
	ataque1,
	ataque2,
	ataque3,
	emote,
	derrota, # Ironicamente no es animación de su derrota sino de la señal derrota general, así que aca estara festejando.
	victoria # Y aca estara triste y se estrellará en la tierra.
}
var estadoActual: estadoM = estadoM.nexo
#endregion

#region Basicos

func _ready() -> void:
	sprite.play("quieto")
	Global.derrota.connect(Callable(self,"destruir"))
	# inicia el timer para los ataques y mueve a Dr Medusa
	_iniciar()
func _iniciar():
	velocity = Vector2(velocidadBase,0)
	timerAtaque.wait_time = randf_range(minTiempo, maxTiempo)
	timerAtaque.start()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()

func destruir():
	if is_queued_for_deletion():
		return
	queue_free()

func morir():
	if is_queued_for_deletion():
		return
	Global.dañoDrMedusa.emit(0)
	Global.enemigo_destruido.emit(300)
	Global.victoria.emit()
	queue_free()

func volver_nexo():
	estadoActual = estadoM.nexo

func mostrar_estado_actual(ubicacion:String):
	print("ubicacion: ", ubicacion, ", estado Actual: ", estadoActual)
#endregion

#region Estados

func cambiar_actual(): # Elije un estado de forma semialeatoria 
	# puede que no sea la mejor forma pero es de la que mejor entiendo que quiero hacer haha
	# 45% -> Ataque 1
	# 25% -> Ataque 2
	# 25% -> Ataque 3
	# 5% -> Tira emote (aparece, y tira emote, no hace nada más) 
	var prob = randi_range(0,99)
	if prob <= 45:
		estadoActual = estadoM.ataque1
	elif prob > 45 and prob <= 70:
		estadoActual = estadoM.ataque2
	elif prob > 70 and prob <= 95:
		estadoActual = estadoM.ataque3
	elif prob > 95 and prob <= 99:
		estadoActual = estadoM.emote

func cambio_estado() -> void: # Ejecuta las acciones de los distintos estados
	if estadoActual == estadoM.ataque1:
		await ataque1()
		volver_nexo()
	elif estadoActual == estadoM.ataque2:
		await ataque2()
		volver_nexo()
	elif estadoActual == estadoM.ataque3:
		await ataque3()
		volver_nexo()
	elif estadoActual == estadoM.emote:
		await emote()
		volver_nexo()
	elif estadoActual == estadoM.derrota:
		destruir()
	elif estadoActual == estadoM.victoria:
		destruir()

#endregion

#region Ataques

func aparecer():
	velocity = Vector2(0,0)
	velocity = Vector2(0, 200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
func ocultar():
	velocity = Vector2(0,-200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
	velocity = Vector2(velocidadBase,0)

func ataque1():
	await aparecer()
	sprite.play("ataque")
	crear_tentaculo()
	await get_tree().create_timer(4.0).timeout
	await ocultar()

func crear_tentaculo():
	var pos = randi_range(75,700)
	var a = ADVERTENCIA.instantiate()
	a.iniciar(pos)
	get_tree().root.add_child(a)
	await get_tree().create_timer(1.5).timeout
	var t = TENTACULO.instantiate()
	t.iniciar(pos)
	get_tree().root.add_child(t)

func ataque2():
	await aparecer()
	sprite.play("risa")
	crear_bomba()
	await get_tree().create_timer(4.0).timeout
	await ocultar()

func crear_bomba():
	var b = BOMBA.instantiate()
	b.iniciar(global_position)
	get_tree().root.add_child(b)

func ataque3():
	await aparecer()
	sprite.play("quieto")
	crear_paraguas()
	await get_tree().create_timer(4.0).timeout
	await ocultar()

func crear_paraguas():
	var p = PARAGUAS.instantiate()
	add_child(p)
	p.iniciar()
	await get_tree().create_timer(4.0).timeout
	p.destruir()

func emote():
	await aparecer()
	sprite.play("emote")
	await get_tree().create_timer(4.0).timeout
	await ocultar()
#endregion

#region Otros

func _on_disparar_t_timeout() -> void:
	cambiar_actual()
	await cambio_estado()
	timerAtaque.wait_time = randf_range(minTiempo, maxTiempo)
	timerAtaque.start()

func todo():
	# func aparecer():
	velocity = Vector2(0,0)
	velocity = Vector2(0,200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
	# func esperar():
	await get_tree().create_timer(4.0).timeout
	# func ocultarse():
	velocity = Vector2(0,-200)
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(0,0)
	velocity = Vector2(velocidadBase,0)
#endregion


func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if contar < vida:
		Global.dañoDrMedusa.emit(vida - contar)
		contar += 1
		sprite.play("dañado")
		if body.has_method("destruir"):
			body.destruir()
	elif contar == vida:
		if body.has_method("destruir"):
			body.destruir()
		morir()
