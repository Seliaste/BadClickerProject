extends Node


# Declare member variables here. Examples:
var money : float = 0
var clickValue = 1
var rawcps = 0
var cpsMultiplier = 1
var cpsLabel = 0
var level = 1
var moneyLabel = "-"
const MAX_DIGITS: int = 10


func Upgrade(cost,type,amount):
	var multiplier = get_node("../mainPanel/OptionButton").get_selected_id()
	if cost*multiplier<=money:
		money -= cost*multiplier
		match type:
			"rawcps":
				rawcps+=amount*multiplier
				return true
			"cpsMultiplier":
				cpsMultiplier+=amount*multiplier
				return true
			"clickValue":
				clickValue+=amount*multiplier
				return true
			_: return false
	else: return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	money += delta*rawcps*cpsMultiplier 
	if money < 100000:
		moneyLabel = str(round(money))
	else: 
		var _exp = str(money).split(".")[0].length() - 1
		var _dec = "%4.3f" % (money/pow(10,_exp))
		moneyLabel = "%sE%s" % [str(_dec), str(_exp)]
	
	get_node("Camera2D/MoneyLabel").set_text("Money: " + moneyLabel +"$")
	
	var _cps=rawcps*cpsMultiplier
	if _cps < 100000:
		cpsLabel = str(round(_cps))
	else: 
		var _exp = str(_cps).split(".")[0].length() - 1
		var _dec = "%10.3f" % _cps / pow(10,_exp)
		cpsLabel = "%sE%s" % [ _dec, str(_exp)]

	get_node("Camera2D/InfoLabel").set_text("CPS: " + cpsLabel+ "\nLevel: " + str(level) + "\nclick Value: " + str(clickValue))

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE:
			var success = get_tree().change_scene("res://mainMenu/mainMenu.tscn")
			if success != OK:
				print("Failed to change scene")
	else: pass


func _on_Button_pressed():
	money += clickValue


func _on_BuyButton_pressed():
	Upgrade(20,"rawcps",1)

func _on_BuyButton2_pressed():
	Upgrade(200,"rawcps",15)
	
	
func _on_BuyButton3_pressed():
	Upgrade(50,"clickValue",rawcps)
	
	
func _on_BuyButton4_pressed():
	Upgrade(75,"cpsMultiplier",0.2)


func _on_LevelUpButton_pressed():
	pass # Replace with function body.


func _on_DebugButton_pressed():
	money += 10000000
