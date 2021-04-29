extends Container


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const buttonTypes = ["cpsMultiplier","rawcps","clickValue"]
const messages = {"cpsMultiplier": "% DPS", "rawcps": " DPS", "clickValue": " SD"}
const baseVals = {"cpsMultiplier":2 , "rawcps": 4 , "clickValue": 1}
const rarityColors = [Color(0, 0, 0),Color("#35db56"),Color("#1888de"),Color("#8818de"),Color("#ff6a00")]
var buttonParameters = [[],[],[],[],]
var rng = RandomNumberGenerator.new()
var rerollCost =25 
onready var player = get_node("/root/Node2D/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	if player.level == 1:
		Reroll()



func _on_Reroll_pressed():
	if rerollCost <= player.money:
		player.money -= rerollCost
		Reroll()



func Reroll():
	var level = player.level
	for i in range(4):
		var rarity = 1
		for _j in range(3):
			rng.randomize()
			if rng.randi_range(1,2) == 2:
				rarity += 1
			else:break
		var type = buttonTypes[rng.randi_range(0,len(buttonTypes)-1)]
		var cost = ceil(rng.randf_range(0.80,1.20)*10*level)*2
		var val = ceil(rng.randf_range(0.8,1.2)*baseVals[type]*(rarity/4+1)*(level)/4)
		buttonParameters[i] = [cost,type,val,rarity]
		var node = get_node("/root/Node2D/mainPanel/buyContainer/BuyButton"+str(i+1))
		node.set_text(str(cost)+"$ : +"+str(val)+str(messages[type]))
		node.add_color_override("font_color", rarityColors[rarity])
		print(rarityColors[rarity])