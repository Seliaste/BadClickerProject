extends VBoxContainer


# Declare member variables here. Examples:
onready var player = get_node("/root/Node2D/Player")
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(0,7):
		var temp = get_node("Row"+str(i))
		for btn in temp.get_children():
			btn.connect("pressed", self, "_upgradefnc", [btn,btn.name.left(3)])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _upgradefnc(button, type):
	if player.money >= 500:
		player.money-=500
		for btn in button.get_parent().get_children():
			btn.visible=false
		button.visible=true
		button.disabled=true
		match type:
			"DPS":
				player.rawcps+=100
			"HIT":
				player.clickValue+=1000
			"RWD":
				player.rewardmp*=2
			"MTP":
				player.multimp*=2
			"PWR":
				player.currpowr+=2
