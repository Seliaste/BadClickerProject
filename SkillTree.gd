extends VBoxContainer


# Declare member variables here. Examples:
onready var player = get_node("/root/Node2D/Player")
onready var label = $SkillTreeLabel
var stlevel = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	print(player.skills)
	yield(get_tree().create_timer(0.01), "timeout") # Wait to allow skills to have been loaded first
	print(player.skills)
	stlevel = len(player.skills) + 1
	label.text = "SKILL TREE : Upgrades for "+str(500*stlevel)+"$"
	for i in range(0,7):
		var temp = get_node("Row"+str(i))
		var validRow = true
		for btn in temp.get_children():
			print(btn.name)
			if player.skills.has(btn.name):
				validRow = false
				btn.disabled = true
				print("UI")
		if validRow == true:
			for btn in temp.get_children():
				btn.connect("pressed", self, "_upgradefnc", [btn,btn.name.left(3)])
				if i != 0:
					btn.visible=false
		else:
			for btn in temp.get_children():
				print(btn)
				if btn.disabled != true:
					btn.visible=false



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _upgradefnc(button, type):
	if player.money >= 500*stlevel:
		player.money-=500*stlevel
		for btn in button.get_parent().get_children():
			btn.visible=false
		button.visible=true
		button.disabled=true
		stlevel+=1
		label.text = "SKILL TREE : Upgrades for "+str(500*stlevel)+"$"
		if stlevel != 7:
			var temp = get_node("Row"+str(stlevel-1))
			for btn in temp.get_children():
				btn.visible=true
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
		player.skills.append(button.name)
