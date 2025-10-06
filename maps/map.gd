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
				mousePos = get_global_mouse_position()  # ✅ corregido
		else:
			if isMouseDown and ball.linear_velocity.length() < minStopSpeed:
				isMouseDown = false
				var dragVector = ball.global_position - mousePos  # ✅ corregido
				var force = dragVector.normalized() * min(dragVector.length() * powerScale, maxForce)
				ball.apply_impulse(force)  
		queue_redraw()

	if event is InputEventMouseMotion and isMouseDown:
		mousePos = get_global_mouse_position()  # ✅ corregido
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

func _on_ball_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int):
	var waterTiles = [ Vector2i(3, 6), Vector2i(4, 6), Vector2i(5, 6),
		Vector2i(3, 7), Vector2i(4, 7), Vector2i(5, 7),
		Vector2i(3, 8), Vector2i(4, 8), Vector2i(5, 8),
		Vector2i(4, 9), Vector2i(5, 9), Vector2i(4, 10),
		Vector2i(5, 10), Vector2i(0, 11)]
	
	var sandTiles = [Vector2i(0, 10), Vector2i(1, 10), Vector2i(2, 10), Vector2i(3, 10),
		Vector2i(1, 11), Vector2i(2, 11), Vector2i(3, 11), Vector2i(4, 11),
		Vector2i(5, 11), Vector2i(1, 12), Vector2i(2, 12), Vector2i(3, 12),
		Vector2i(4, 12), Vector2i(5, 12)]
	
	if body is TileMap:
		var tilemap = body as TileMap
		var cell = tilemap.local_to_map(ball.global_position)
		var atlasCoords = tilemap.get_cell_atlas_coords(0, cell)

		if atlasCoords in waterTiles:
			ball.global_position = ball.start_position
			ball.linear_velocity = Vector2.ZERO
			powerScale = basePowerScale 

		elif atlasCoords in sandTiles:
			ball.linear_velocity *= 0.3
			powerScale = max(basePowerScale * 0.5, 1.0) 
		else:
			powerScale = basePowerScale 
