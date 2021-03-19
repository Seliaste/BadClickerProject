extends Node


var life : float = 0
var maxlife = 0
onready var player = get_node("/root/Node2D/Player")
onready var lifebar = get_node("/root/Node2D/Monster/VBoxContainer/ProgressBar")
onready var logs = get_node("/root/Node2D/Monster/VBoxContainer/Log")
var rng = RandomNumberGenerator.new()

func _ready():
	spawnBoss()

func spawnBoss():
	rng.randomize()
	maxlife = ceil(10 * rng.randf_range(0.9,1.1) * player.level)
	life = maxlife
	refreshLife()

func damage(damageAmount: float, showdmg = false):
	if damageAmount > 0:
		life -= damageAmount
		if showdmg:
			logs.text += "Damage: " + str(damageAmount) + "\n"
		if life <= 0:
			var remainingdmg = -life
			spawnBoss()
			var earnedMoney = rng.randi_range(2,10) * player.level
			if logs.text.length() > 2000:
				logs.text = logs.text.right(100) + "You killed the monster and won : "+str(earnedMoney)+" $ \n"
			else: 
				logs.text += "You killed the monster and won : "+str(earnedMoney)+" $ \n"
			player.money += earnedMoney
			damage(remainingdmg)
		refreshLife()

func refreshLife():
	lifebar.value = (life/maxlife)*100
	lifebar.hint_tooltip = str(life)+"/"+str(maxlife)
