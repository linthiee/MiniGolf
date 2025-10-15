extends Control

@onready var btnStart: Button = $Start
@onready var btnExit: Button = $Exit

func _on_start_button_up() -> void:
	LevelManager.reset()
	get_tree().change_scene_to_file("res://maps/map.tscn")

func _on_exit_button_up() -> void:
	get_tree().quit()
