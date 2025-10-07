extends Area2D
@onready var ball: RigidBody2D = get_node("../Ball")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("You won!") #change to go to next level
