extends Control

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("uid://bfoyeoguerq2j")

func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file("uid://dcigxps7xjncl")

func _on_salir_pressed() -> void:
	get_tree().quit()
