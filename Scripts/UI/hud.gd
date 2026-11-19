extends CanvasLayer
# Soy un atrevido, como voy a tener logica y controladores de juego en el HUD HAHAHA
# Para esto debo hacer un GameController, chicos no hagan lo que yo hice en casa.
# Para proximos SPRINTS lo corrijo? un like y lo arreglo
# Temporizadores
@onready var tiempoJ: Timer = $TiempoJuego
@onready var inicioT: Timer = $InicioTimer
@onready var peligroT: Timer = $PeligroT
# Etiquetas
@onready var mensaje: Label = $Mensaje
@onready var puntuacion: Label = $Puntuacion
@onready var tiempoE: Label = $Tiempo
#Variables
var segAumentaNivel = [10,20,60,120,180]
var nivel = 0
var cont = 0
var punt = 0
@export var vida = 10
@export var condicionVictoria = 100
var unicavez:bool=true
var unavez:bool=true
# Otros
@onready var barraVida: TextureRect = $TextureRect
# Preloads
const bv0 = preload("uid://bby8mg2nlfqjb")
const bv1 = preload("uid://dxrcae1litxj5")
const bv2 = preload("uid://deru1p5ghu4j4")
const bv3 = preload("uid://ciqfw652dkm8v")
const bv4 = preload("uid://dwfw6umpnk16r")
const bv5 = preload("uid://ccrrbnb86ciat")
const bv6 = preload("uid://dx2qubel5a567")
const bv7 = preload("uid://drbmyxafwmptt")
const bv8 = preload("uid://4s8fa56i2okd")
const bv9 = preload("uid://ygq8laa04hrp")
const bv10 = preload("uid://lcce61tcg685")

func _ready() -> void:
	_iniciarTimer()
	Global.enemigo_destruido.connect(Callable(self,"_enemigo_destruido"),10)
	Global.pon_daño.connect(Callable(self,"_pon_recibe_daño"))

func _process(_delta: float) -> void:
	#_condicion_victoria_p()
	_cronometro()

func _cronometro():
	# Calcula el tiempo restante restando el tiempo transcurrido al tiempo total
	var tiempo_restante: float = tiempoJ.wait_time - tiempoJ.time_left
	# Da formato al texto para mostrar minutos y segundos (MM:SS)
	var minutos: int = int(tiempo_restante) / 60
	var segundos: int = int(tiempo_restante) % 60
	# Actualiza el Label usando formato con ceros a la izquierda
	tiempoE.text = "%02d:%02d" % [minutos, segundos]
	if int(tiempo_restante) in segAumentaNivel and unavez:
		nivel+=1
		Global.aumentarDificultad.emit(nivel)
		_mostrar_dificultad_aumentada()
		unavez = false
	elif int(tiempo_restante-5) in segAumentaNivel and not(unavez):
		unavez = true

func _mostrar_dificultad_aumentada():
	mensaje.text='Peligro!!!'
	peligroT.start()
# esta condicion de victoria es por tiempo
func _condicion_victoria_t():
	Global.puntuacion = punt
	Global.victoria.emit()

# esta condicion de victoria es por puntos
func _condicion_victoria_p():
	if punt >= condicionVictoria and unicavez:
		Global.puntuacion = punt
		Global.victoria.emit()
		unicavez = false

func _iniciarTimer():
	cont+=1
	mensaje.text = "Nave Preparada!"
	inicioT.start()

func _pon_recibe_daño():
	vida -= 1
	_controlador_barra_de_vida()
	if vida <= 0:
		Global.puntuacion = punt
		Global.derrota.emit()

func _enemigo_destruido(puntos:int):
	punt+= puntos
	puntuacion.text= str(punt)

func _on_inicio_timer_timeout() -> void:
	cont+=1
	match cont:
		1:
			mensaje.text = "Este texto se coló por un agujero de gusano"
			inicioT.start()
		2:
			mensaje.text = "Pon Preparado!"
			inicioT.start()
		3:
			mensaje.text = "Salva al Mundo!"
			inicioT.start()
		5:
			mensaje.text = ""
		6:
			$InicioTimer.stop()

func _controlador_barra_de_vida():
	# tambien podria haber usado un vector con los preloads, y moverme una posición cada vez
	match vida:
		0:barraVida.texture = bv0
		1:barraVida.texture = bv1
		2:barraVida.texture = bv2
		3:barraVida.texture = bv3
		4:barraVida.texture = bv4
		5:barraVida.texture = bv5
		6:barraVida.texture = bv6
		7:barraVida.texture = bv7
		8:barraVida.texture = bv8
		9:barraVida.texture = bv9
		10:barraVida.texture = bv10

func _on_tiempo_juego_timeout() -> void:
	_condicion_victoria_t()

func _on_peligro_t_timeout() -> void:
	mensaje.text=''
	peligroT.stop()
