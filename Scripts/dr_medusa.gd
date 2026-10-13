extends CharacterBody2D
# Idea: puedo hacer ataques predeterminados y de ahi que vaya eligiendo que ataque usar
# Ataque 1) golpe con tentaculo: Dr medusa se muestra por un segundo o dos y luego ataca en esa misma direccion (podria ser fuego tambien del cohete).
# Ataque 2) lluvia de bombas: tira 3 o 4 bombas al mismo tiempo, caen todas a la par dejando un espacio en medio para pasar, se muestra en el medio y rie malevolamente antes de atacar.
# Ataque 3) paraguas escudo: aparece y usa un paraguas para reflejar el ataque de pon, lo transforma en dos ataques.
# Dr Medusa sera implementado como maquina de estados
var tiempoAtaque: float = 10.0
@onready var timerAtaque: Timer = $dispararT
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

func _ready() -> void:
	Global.derrota.connect(Callable(self,"destruir"))
	Global.victoria.connect(Callable(self,"destruir"))
	# inicia el timer para los ataques y mueve a Dr Medusa
	_iniciar()
func _iniciar():
	timerAtaque.wait_time = tiempoAtaque
	timerAtaque.start()
	velocity = Vector2(150,0)
func destruir():
	queue_free()
func _volver_nexo():
	estadoActual == estadoM.nexo

func _prob_estado() -> String: # Elije un estado de forma semialeatoria 
	# puede que no sea la mejor forma pero es de la que mejor entiendo que quiero hacer haha
# 45% -> Ataque 1
# 25% -> Ataque 2
# 25% -> Ataque 3
# 5% -> Tira emote (aparece, y tira emote, no hace nada más) 

	var prob = randi_range(0,99)
	var ataque1 = range(45)
	var ataque2 = range(45,70)
	var ataque3 = range(70,95)
	var emote = range(95,100)
	if prob in ataque1:
		return "ataque1"
	elif prob in ataque2:
		return "ataque2"
	elif prob in ataque3:
		return "ataque3"
	elif prob in emote:
		return "emote"
	else:
		return "error"
func _cambios(): # Aplica el cambio de estado con respecto al anterior procedimiento
	if estadoActual == estadoM.nexo:
		var proximoMovimiento = _prob_estado()
		if proximoMovimiento == "ataque1":
			estadoActual = estadoM.ataque1
		elif proximoMovimiento == "ataque2":
			estadoActual = estadoM.ataque2
		elif proximoMovimiento == "ataque3":
			estadoActual = estadoM.ataque3
		elif proximoMovimiento == "emote":
			estadoActual = estadoM.emote
		else:
			print("Ocurrio un error")
func _physics_process(delta: float) -> void: # Ejecuta las acciones de los distintos estados
	if estadoActual == estadoM.ataque1:
		_ataque1()
		_volver_nexo()
	elif estadoActual == estadoM.ataque2:
		_ataque2()
		_volver_nexo()
	elif estadoActual == estadoM.ataque3:
		_ataque3()
		_volver_nexo()
	elif estadoActual == estadoM.emote:
		_emote()
		_volver_nexo()
	elif estadoActual == estadoM.derrota:
		destruir()
	elif estadoActual == estadoM.victoria:
		destruir()


func _ataque1():
	pass
func _ataque2():
	pass
func _ataque3():
	pass
func _emote():
	pass

func _on_disparar_t_timeout() -> void:
	_cambios()
	timerAtaque.wait_time = tiempoAtaque
	timerAtaque.start()
