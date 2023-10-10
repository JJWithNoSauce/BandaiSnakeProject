extends Node2D
class_name SelectParent

var aim:PackedScene = load("res://scene/component/ui/aim.tscn")
signal selectPlayer(players)
var players = []
var act = false

func _ready():
	get_parent().connect("isActivate",activate)
	add_to_group("card")

func _process(delta):
	pass

func activate(p):
	act = p
	if act : genSelect()
	
func genSelect(): pass

func setTarget(player,canSelect):
	var ins = aim.instantiate()
	ins.init(player,canSelect)
	add_child(ins)
	ins.connect("selectPlayer",getSelectPlayer)

func getSelectPlayer(player):
	players.append(player)

func on_useCard():
	if not act : return
	await Lib.wait(0.1)
	selectPlayer.emit(players)
