extends Control


func saveGame():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	saveGame()


func _on_Return_pressed():
	get_parent().get_node("Player/Camera2D").set_position(Vector2(640	,360))
