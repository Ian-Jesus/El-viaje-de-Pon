extends Node
const max_punt = "res://max_punt.dat"
signal enemigo_destruido(_puntos:int)
signal pon_daño
signal derrota
signal victoria
signal aumentarDificultad(nivelDificultad:int)
var puntuacion:int = 0
var datos_max:Dictionary={
	"max":0
}

func _ready() -> void:
	derrota.connect(Callable(self,"_derrota"))
	victoria.connect(Callable(self,"_victoria"))

func _victoria():
	guardar_max_puntuacion()
#	get_tree().change_scene_to_file("uid://ckoiffb6wcmpj")
	call_deferred("_cambiar_escena_v")

func _derrota():
	guardar_max_puntuacion()
	call_deferred("_cambiar_escena_d")

func _cambiar_escena_v():
	get_tree().change_scene_to_file("uid://b71q1rtiudscd")
	
func _cambiar_escena_d():
	get_tree().change_scene_to_file("uid://b8gi5dfubn3ib")

func guardar_max_puntuacion():
	if puntuacion > datos_max["max"]:
		datos_max["max"] = puntuacion
		var archivo = FileAccess.open(max_punt,FileAccess.WRITE)
		archivo.store_var(datos_max)
		archivo = null

func cargar_max_puntuacion():
	if FileAccess.file_exists(max_punt):
		var archivo = FileAccess.open(max_punt,FileAccess.READ)
		datos_max = archivo.get_var()
		archivo = null
