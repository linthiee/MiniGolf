extends Node2D

var mousePos: Vector2 = Vector2.ZERO
var isMouseDown := false
var maxForce := 250  
var powerScale := 2.0   
var minStopSpeed := 10.0
var basePowerScale := 2.0 
var currentLevel := 1

var isPaused = false

@onready var ball: RigidBody2D = $Ball
@onready var camera: Camera2D = $Camera2D
@onready var overlay = $CanvasLayer/Control

func _ready():	
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS
	overlay.process_mode = Node.PROCESS_MODE_ALWAYS

	overlay.retryPressed.connect(onRetry)
	overlay.menuPressed.connect(onMenu)
	overlay.resumePressed.connect(onResume) 
	overlay.nextPressed.connect(onNextLevel)
	
	updateUi()

func onRetry():
	restartLevel()

func onNextLevel():
	LevelManager.nextLevel()

func onResume():
	if get_tree().paused:
		get_tree().paused = false
		isPaused = false
		overlay.hideScreen()

func onMenu():
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")

func onLose():
	overlay.showScreen("lose")
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")

func onPause():
	get_tree().paused = not get_tree().paused
	isPaused = get_tree().paused
	
	if isPaused:
		overlay.showScreen("pause")
	else:
		overlay.hideScreen()

func restartLevel():
	get_tree().paused = false
	isPaused = false
	overlay.hideScreen()
	LevelManager.restart_current_level()
	
	updateUi()

func paused(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			onPause()
			pass

func _input(event: InputEvent) -> void:
	paused(event)
	
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
				registerMove()
				if ball.collision:
					print("ano")
		queue_redraw()

	if event is InputEventMouseMotion and isMouseDown:
		mousePos = get_global_mouse_position()  
		queue_redraw()

func registerMove():
	if ball.moves == ball.maxMoves:
		onLose()
	
	if ball.moves < ball.maxMoves:
		ball.moves += 1
	updateUi()

func updateUi():
	print("Movements: ", ball.moves, "/", ball.maxMoves)
	$Movements.text = "Movements: " + str(ball.moves) + "/" + str(ball.maxMoves)

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

func _physics_process(_delta):
	if ball.linear_velocity.length() > 5:
		ball.linear_velocity *= 0.98
	elif ball.linear_velocity.length() < 5:
		ball.linear_velocity = Vector2.ZERO
