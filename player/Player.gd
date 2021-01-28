extends Node


# Declare member variables here. Examples:
var money = 0
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#get_node("Camera2D/MoneyLabel").text = "Money: " + money

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			var success = get_tree().change_scene("res://mainMenu/mainMenu.tscn")
			if success != OK:
				print("Failed to change scene")
