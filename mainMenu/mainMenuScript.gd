extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_button_down():
	var _newScene=get_tree().change_scene("res://gameScene.tscn")


func _on_Button2_button_down():
	get_tree().quit()



func _on_Button3_button_down():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
	var _newScene=get_tree().change_scene("res://gameScene.tscn")


func _on_Button_ready():
	print(get_tree().get_root())
	if not File.new().file_exists("user://savegame.save"):
		var buttonToHide = get_tree().get_root().get_node("Node2D/menuAnchor/Button") 
		buttonToHide.set_visible(false)
