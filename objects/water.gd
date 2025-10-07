extends Area2D

@onready var ball: RigidBody2D = get_node("../Ball")

func _on_ball_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		ball.call_deferred("resetPosition")
