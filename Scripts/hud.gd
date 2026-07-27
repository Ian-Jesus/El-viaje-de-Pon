extends CanvasLayer
# cuando se gana no guarda la puntuacion 
@onready var inicioT: Timer = $InicioTimer
@onready var mensaje: Label = $Mensaje
@onready var puntuacion: Label = $Puntuacion
var vida = 3
var cont = 0
var punt = 0
@export var condicionVictoria = 100
var unicavez:bool=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iniciarTimer()
	Global.enemigo_destruido.connect(Callable(self,"_enemigo_destruido"),10)
	Global.pon_daño.connect(Callable(self,"_pon_recibe_daño"))

func _process(delta: float) -> void:
	
	if punt >= condicionVictoria and unicavez:
		Global.victoria.emit()
		unicavez = false

func iniciarTimer():
	cont+=1
	mensaje.text = "Nave Preparada!"
	inicioT.start()

func _pon_recibe_daño():
	vida -= 1
	if vida <= 0:
		Global.puntuacion = punt
		Global.derrota.emit()

func _enemigo_destruido(puntos):
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
			mensaje.text = "Motor de propulsión líquida que opera bajo un ciclo generador de gas de alta presión Preparado!"
			inicioT.start()
		5:
			mensaje.text = ""
		6:
			$InicioTimer.stop()
