extends Control
var puntos:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/n.text = str(Global.puntuacion)
	$VBoxContainer/max.text= str(Global.datos_max["max"])

func _on_volver_al_menu_pressed() -> void:
	get_tree().change_scene_to_file("uid://bns1q41lv38yg")


func _on_volver_a_intentar_pressed() -> void:
	get_tree().change_scene_to_file("uid://36p6jvu502qk")
