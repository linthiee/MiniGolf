extends Node2D

var mousePos: Vector2 = Vector2.ZERO
var isMouseDown := false
var maxForce := 250  
var powerScale := 2.0   
var minStopSpeed := 10.0
var basePowerScale := 2.0 

@onready var ball: RigidBody2D = $Ball
@onready var camera: Camera2D = $Camera2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if ball.linear_velocity.length() < minStopSpeed:
				isMouseDown = true
				mousePos = get_global_mouse_position() 
		else:
			if isMouseDown and ball.linear_velocity.length() < minStopSpeed:
				isMouseDown = false
				var dragVector = ball.global_position - mousePos 
				var force = dragVector.normalized() * min(dragVector.length() * powerScale, maxForce)
				ball.apply_impulse(force)  
				ball.registerMove()
		queue_redraw()

	if event is InputEventMouseMotion and isMouseDown:
		mousePos = get_global_mouse_position()  
		queue_redraw()

func _draw() -> void:
	if isMouseDown:
		var color = Color.CORNSILK
		var ball_local = to_local(ball.global_position)
		var endPoint_local = to_local(mousePos)
		var distance = ball_local.distance_to(endPoint_local)
		
		if distance > 100:
			var direction = (endPoint_local - ball_local).normalized()
			endPoint_local = ball_local + direction * 100
			
		if distance < 25:
			color = Color.GREEN_YELLOW
		elif distance < 50:
			color = Color.YELLOW
		elif distance < 75:
			color = Color.INDIAN_RED
		else:
			color = Color.DARK_RED
			
		draw_line(ball_local, endPoint_local, color, 2.0)

func _physics_process(delta):
	if ball.linear_velocity.length() > 5:
		ball.linear_velocity *= 0.98
	elif ball.linear_velocity.length() < 5:
		ball.linear_velocity = Vector2.ZERO
