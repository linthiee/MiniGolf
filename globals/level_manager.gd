extends Node

@export var levelPaths: Array[String]
var currentLevelPath: String = ""

func _ready():
	currentLevelPath = levelPaths[0]
	#if currentLevelPath == "":
		#initialLevel()

func reset():
	currentLevelPath = levelPaths[0]

func initialLevel():
	currentLevelPath = levelPaths[0]
	get_tree().call_deferred("change_scene_to_file", currentLevelPath)

func restart_current_level():
	if currentLevelPath != "":
		get_tree().change_scene_to_file(currentLevelPath)
	else:
		pass

func nextLevel():
	var idx = levelPaths.find(currentLevelPath)

	print("Next level: " ,idx )

	if idx + 1 < levelPaths.size():
		currentLevelPath = levelPaths[idx + 1]
	else:
		currentLevelPath = levelPaths[0]
	get_tree().paused = false
	get_tree().change_scene_to_file(str(currentLevelPath))
