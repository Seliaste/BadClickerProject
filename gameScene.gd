extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = JSON.parse(save_game.get_line()).result
		var player = get_node("Player")
		if current_line != null:
			for i in current_line.keys():
				if i == "filename" or i == "parent":
					continue
				print(i, current_line[i])
				player.set(i, current_line[i])
	save_game.close() 
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
