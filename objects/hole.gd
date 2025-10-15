extends Area2D
@onready var ball: RigidBody2D = get_node("../Ball")
@onready var overlay = $"../CanvasLayer/Control"

func onWin():
	get_tree().paused = true
	overlay.showScreen("win")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		onWin() 
