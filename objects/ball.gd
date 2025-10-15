extends RigidBody2D

var startPosition: Vector2

var moves = 0
var maxMoves = 5

func _ready():
	startPosition = global_position

func resetPosition() -> void:
	freeze = true                  
	global_position = startPosition 
	move_and_collide(startPosition)
	linear_velocity = Vector2.ZERO     
	angular_velocity = 0
	freeze = false                 
