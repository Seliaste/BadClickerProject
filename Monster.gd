extends Node


var life : float = 0
var maxlife = 0
onready var player = get_node("/root/Node2D/Player")
onready var lifebar = get_node("/root/Node2D/Monster/VBoxContainer/ProgressBar")
onready var logs = get_node("/root/Node2D/Monster/VBoxContainer/Log")
var rng = RandomNumberGenerator.new()
var monsterNum = 1 
var currmonsterNum = 1
var isSpawned = true

func _ready():
	spawnBoss()

func spawnBoss():
	currmonsterNum = monsterNum
	rng.randomize()
	maxlife = ceil(10 * rng.randf_range(0.9,1.1) * (pow(player.level,2)) * currmonsterNum)
	life = maxlife
	refreshLife()

func damage(damageAmount: float, showdmg = false):
	if damageAmount > 0 and isSpawned == true:
		life -= damageAmount
		if showdmg:
			logs.text += "Damage: " + str(damageAmount) + "\n"
		if life <= 0:
			var remainingdmg = -life
			var earnedMoney = rng.randi_range(2,10) * player.level * currmonsterNum * player.rewardmp
			var deathMessage = ""
			match currmonsterNum:
				1:
					deathMessage = "You killed the monster and won : "+str(earnedMoney)+" $ \n"
				5:
					deathMessage = "You killed 5 monsters and won : "+str(earnedMoney)+" $ \n"
				25:
					deathMessage = "You killed 25 monsters and won : "+str(earnedMoney)+" $ \n"
				500:
					deathMessage = "You killed 500 monsters and won : "+str(earnedMoney)+" $ \n"
			if logs.text.length() > 2000:
				logs.text = logs.text.right(100) + deathMessage
			else: 
				logs.text += deathMessage
			player.money += earnedMoney
			player.killed += currmonsterNum
			isSpawned = false
			lifebar.value = 0
			yield(get_tree().create_timer(0.2), "timeout")
			spawnBoss()
			damage(remainingdmg)
			isSpawned = true
		refreshLife()

func refreshLife():
	lifebar.value = (life/maxlife)*100
	lifebar.hint_tooltip = str(life)+"/"+str(maxlife)

func _on_OptionButton_item_selected(_index: int):
	monsterNum = get_node("VBoxContainer/OptionButton").get_selected_id()
	spawnBoss()
