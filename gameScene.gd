extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var current_line = JSON.parse(save_game.get_line()).result
	var player = get_node("Player")
	if current_line != null:
		for i in current_line.keys():
			if i == "filename" or i == "parent":
				continue
			elif i == "newLevelCost":
				get_node("/root/Node2D/mainPanel/buyContainer/LevelUp").text = str(current_line[i])+"$ : Level Up"
				get_node("/root/Node2D/mainPanel/buyContainer/Reroll").text = str(current_line[i]/2)+"$ : Reroll"
			player.set(i, current_line[i])
			
	var camera = get_node("Player/Camera2D")
	camera.current=true
	camera.set_position(Vector2(0	,0))
	save_game.close() 
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
