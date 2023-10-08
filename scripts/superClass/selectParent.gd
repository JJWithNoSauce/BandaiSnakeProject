extends Node2D
class_name SelectParent

var aim:PackedScene = load("res://scene/component/ui/aim.tscn")
signal selectPlayer(players)
var players = []

func _ready():
	get_parent().connect("isActivate",activate)

func _process(delta):
	pass

func activate(p):
	if p : genSelect()
	
func genSelect(): pass

func setTarget(player,canSelect):
	var ins = aim.instantiate()
	ins.init(player,canSelect)
	add_child(ins)
	ins.connect("selectPlayer",getSelectPlayer)

func getSelectPlayer(player):
	players.append(player)
