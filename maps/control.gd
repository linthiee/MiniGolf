extends Control

signal retryPressed
signal menuPressed
signal resumePressed
signal nextPressed 

var currentScreen := "none"

@onready var label: Label = $Label
@onready var btnResume: Button = $Resume
@onready var btnRetry: Button = $Retry
@onready var btnNext: Button = $NextLevel
@onready var btnMenu: Button = $Menu
@onready var btnExit: Button = $Exit
@onready var rectangle: TextureRect = $TextureRect

func _ready():
	btnRetry.pressed.connect(func(): emit_signal("retryPressed"))
	btnMenu.pressed.connect(func(): emit_signal("menuPressed"))
	btnResume.pressed.connect(func(): emit_signal("resumePressed"))
	btnNext.pressed.connect(func(): emit_signal("nextPressed"))
	emit_signal("retryPressed")
	hideScreen() 

func showScreen(screenName: String):
	hideScreen()
	currentScreen = screenName
	
	match screenName:
		"pause":
			label.text = "Paused"
			btnResume.visible = true
			btnRetry.visible = true
			btnMenu.visible = true
			btnNext.visible = false
			btnExit.visible = true
			rectangle.visible = true

		"lose":
			label.text = "You lost..."
			btnResume.visible = false
			btnRetry.visible = true
			btnMenu.visible = true
			btnNext.visible = false
			btnExit.visible = true
			rectangle.visible = true
		
		"win":
			label.text = "You win!"
			btnResume.visible = false
			btnRetry.visible = true
			btnMenu.visible = true
			btnNext.visible = true  
			btnExit.visible = true
			rectangle.visible = true

func hideScreen():
	label.text = ""
	btnResume.visible = false
	btnRetry.visible = false
	btnNext.visible = false
	btnMenu.visible = false
	btnExit.visible = false
	rectangle.visible = false
	
	currentScreen = "none"

func _on_retry_button_up() -> void:
	hideScreen()
	emit_signal("retryPressed")

func _on_menu_button_up() -> void:
	#hideScreen()
	#emit_signal("menuPressed")
	emit_signal("resumePressed")
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")

func _on_exit_button_up() -> void:
	get_tree().quit()

func _on_resume_pressed() -> void:
	pass

func _on_resume_button_up() -> void:
	hideScreen()
	emit_signal("resumePressed")

func _on_next_level_button_up() -> void:
	hideScreen()
	#emit_signal("nextPressed")
