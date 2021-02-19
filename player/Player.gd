extends Node


# Declare member variables here. Examples:
var money : float = 0
var clickValue = 1
var rawcps = 0
var cpsMultiplier = 1
var cpsLabel = 0
var level = 1
var moneyLabel = "-"
var timePlayed = 0
const MAX_DIGITS: int = 10
var newLevelCost: int = 50
const q = 1.2
onready var buyContainer = get_node("/root/Node2D/mainPanel/buyContainer")
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
		"newLevelCost" : newLevelCost
	}
	return save_dict


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
	money += delta*rawcps*cpsMultiplier 
	if money < 100000:
		moneyLabel = str(round(money))
	else: 
		var _exp = str(money).split(".")[0].length() - 1
		var _dec = "%4.3f" % (money/pow(10,_exp))
		moneyLabel = "%sE%s" % [str(_dec), str(_exp)]
	
	get_node("Camera2D/MoneyLabel").set_text("Money: " + moneyLabel +"$")
	
	var _cps=rawcps*cpsMultiplier
	if _cps < 1000:
		cpsLabel = str(round(_cps))
	else: 
		var _exp = str(_cps).split(".")[0].length() - 1
		var _dec = "%10.3f" % (_cps / pow(10,_exp))
		cpsLabel = "%sE%s" % [ _dec, str(_exp)]

	get_node("Camera2D/InfoLabel").set_text("CPS: " + cpsLabel+ "\nLevel: " + str(level) + "\nclick Value: " + str(clickValue))
	var mousePos = get_viewport().get_mouse_position()
	for node in get_node("/root/").get_children():
		if node.get_global_rect().has_point(mousePos) and node.tooltip!=None :
			pass



func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			get_node("Camera2D").set_position(Vector2(1280,0))
	else: pass


func _on_Button_pressed():
	money += clickValue


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

func _on_UP_pressed():
	get_node("Camera2D").set_position(Vector2(0,-720))

func _on_Down_pressed():
	get_node("Camera2D").set_position(Vector2(0,0))