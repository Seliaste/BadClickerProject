extends Node


# Declare member variables here. Examples:
var money : float = 0
var clickValue = 1
var rewardmp = 1
var multimp = 1
var rawcps = 0
var cpsMultiplier = 1
var cpsLabel = 0
var level = 1
var moneyLabel = "-"
var timePlayed = 0
var newpowr = 1
var currpowr = 1
var killed = 0
var skills = []
const MAX_DIGITS: int = 10
var newLevelCost: int = 50
onready var tooltip = get_node("/root/Node2D/CanvasLayer/Tooltip")
const q = 1.2
onready var buyContainer = get_node("/root/Node2D/mainPanel/buyContainer")
onready var monster = get_node("/root/Node2D/Monster")
onready var ascentionbtn = get_node("/root/Node2D/UpgradesPanel/AscendContainer/AscendButton")
func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"money" : money,
		"clickValue" : clickValue,
		"rawcps" : rawcps,
		"cpsMultiplier" : cpsMultiplier,
		"level" : level,
		"timePlayed" : timePlayed,
		"newLevelCost" : newLevelCost,
		"skills" : skills
	}
	return save_dict


func getallnodes(node):
	var returnList = []
	for N in node.get_children():
		if N.get_child_count() > 0:
			returnList+=getallnodes(N)
		if N is Control:
			returnList.append(N)
		
	return returnList

func Upgrade(cost,type,amount):
	var multiplier = get_node("../mainPanel/OptionButton").get_selected_id()
	if cost*multiplier<=money:
		money -= cost*multiplier
		match type:
			"rawcps":
				rawcps+=amount*multiplier
				return true
			"cpsMultiplier":
				cpsMultiplier+=amount/100*multiplier
				return true
			"clickValue":
				clickValue+=amount*multiplier
				return true
			_: return false
	else: return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timePlayed += delta
	monster.damage(delta*rawcps*(cpsMultiplier*multimp)*currpowr) 
	if money < 100000:
		moneyLabel = str(round(money))
	else: 
		var _exp = str(money).split(".")[0].length() - 1
		var _dec = "%4.3f" % (money/pow(10,_exp))
		moneyLabel = "%sE%s" % [str(_dec), str(_exp)]
	
	get_node("Camera2D/MoneyLabel").set_text("Money: " + moneyLabel +"$")
	
	var _cps=rawcps*cpsMultiplier*currpowr*multimp
	if _cps < 1000:
		cpsLabel = str(round(_cps))
	else: 
		var _exp = str(_cps).split(".")[0].length() - 1
		var _dec = "%10.3f" % (_cps / pow(10,_exp))
		cpsLabel = "%sE%s" % [ _dec, str(_exp)]

	get_node("Camera2D/InfoLabel").set_text("DPS: " + cpsLabel+ "\nLevel: " + str(level) + "\nSlash Damage: " + str(clickValue))
	var mousePos = get_node("/root/Node2D").get_global_mouse_position()
	for node in getallnodes(get_node("/root/Node2D")):
		if node.get_global_rect().has_point(mousePos) and node.hint_tooltip != "":
			tooltip.visible = true
			tooltip.text = node.hint_tooltip
			tooltip.set_global_position(mousePos+Vector2(20,5))
			break
		else:
			tooltip.visible = false
			tooltip.rect_size = Vector2(1,1)

	newpowr = stepify(currpowr + (timePlayed/1000)  + (killed*level / 1000) + (level / 10), 0.01)
	ascentionbtn.text = "Ascend : +%s Power" % str(newpowr-currpowr)
	ascentionbtn.hint_tooltip = "You currently have %s Power" % str(currpowr)



func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_node("Camera2D").set_position(Vector2(1280+640,360))
	else: pass


func _on_Button_pressed():
	monster.damage(clickValue, true)

func _on_BuyButton_pressed():
	# get_node("/root/Node2D/mainPanel/buyContainer/BuyButton1").set_visible("false")
	Upgrade(buyContainer.buttonParameters[0][0],buyContainer.buttonParameters[0][1],buyContainer.buttonParameters[0][2])

func _on_BuyButton2_pressed():
	Upgrade(buyContainer.buttonParameters[1][0],buyContainer.buttonParameters[1][1],buyContainer.buttonParameters[1][2])
	
	
func _on_BuyButton3_pressed():
	Upgrade(buyContainer.buttonParameters[2][0],buyContainer.buttonParameters[2][1],buyContainer.buttonParameters[2][2])
	
	
func _on_BuyButton4_pressed():
	Upgrade(buyContainer.buttonParameters[3][0],buyContainer.buttonParameters[3][1],buyContainer.buttonParameters[3][2])




func _on_DebugButton_pressed():
		money += 10000000


func _on_LevelUp_pressed():
	var multiplier = get_node("../mainPanel/OptionButton").get_selected_id()
	var moneyToPay = 0
	for _i in range(0,multiplier):
		moneyToPay += newLevelCost
		newLevelCost *= q
	if moneyToPay <= money:
		level += multiplier
		money -= moneyToPay
	else: 
		for _i in range(0,multiplier):
			newLevelCost/=q
	get_node("/root/Node2D/mainPanel/buyContainer/LevelUp").text = str(newLevelCost)+"$ : Level Up"
	get_node("/root/Node2D/mainPanel/buyContainer/Reroll").text = str(newLevelCost/2)+"$ : Reroll"
	get_node("/root/Node2D/mainPanel/buyContainer").rerollCost = newLevelCost/2

func _on_UP_pressed():
	get_node("Camera2D").set_position(Vector2(640,-360))
	

func _on_Down_pressed():
	get_node("Camera2D").set_position(Vector2(640,360))

func _on_AscendButton_pressed():
	get_node("/root/Node2D/UpgradesPanel/AscendContainer/CanvasLayer/ConfirmationDialog").popup_centered()

func _on_ConfirmationDialog_confirmed():
	currpowr = newpowr 
	money = 0
	clickValue = 1
	rawcps = 0
	cpsMultiplier = 1
	cpsLabel = 0
	level = 1
	timePlayed = 0
	killed = 0
	buyContainer.Reroll()
	get_node("Camera2D").set_position(Vector2(640,360))
	get_node("/root/Node2D/Monster/VBoxContainer/OptionButton").selected = 0
	monster.monsterNum = get_node("/root/Node2D/Monster/VBoxContainer/OptionButton").get_selected_id()
	monster.spawnBoss()
	newLevelCost = 50
	get_node("/root/Node2D/mainPanel/buyContainer/LevelUp").text = str(newLevelCost)+"$ : Level Up"
	get_node("/root/Node2D/mainPanel/buyContainer/Reroll").text = str(newLevelCost/2)+"$ : Reroll"
	get_node("/root/Node2D/mainPanel/buyContainer").rerollCost = newLevelCost/2
