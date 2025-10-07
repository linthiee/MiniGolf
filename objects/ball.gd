extends RigidBody2D

var startPosition: Vector2

var moves = 0
var maxMoves = 10

func _ready():
	startPosition = global_position
	updateUi()
	
func registerMove():
	moves += 1
	updateUi()
	
	if moves >= maxMoves:
		print("Game over!")

func updateUi():
	print("Movements:", moves, "/", maxMoves)

func resetPosition() -> void:
	updateUi()
	freeze = true                  
	global_position = startPosition 
	move_and_collide(startPosition)
	linear_velocity = Vector2.ZERO     
	angular_velocity = 0
	freeze = false                 
