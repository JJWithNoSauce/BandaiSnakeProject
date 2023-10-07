extends Node2D
var aim:PackedScene = load("res://scene/component/ui/aim.tscn")
signal selectPlayer(players)
var players = []

func _ready():
	get_parent().connect("isActivate",activate)
	pass

func _process(delta):
	pass

func activate(p):
	if p : genSelect()
	
func genSelect():
	var nowPlayer:Player = ActionControl.nowPlayer
	var allPlayer = ActionControl.playersStat
	for i in  allPlayer:
		var player = allPlayer[i]
		if player == nowPlayer: continue
		print(player,"  ",nowPlayer)
		var delStep = nowPlayer.stepNow - player.stepNow
		if abs(delStep) <= 5 :
			setTarget(player,false)

func setTarget(player,canSelect):
	var ins = aim.instantiate()
	ins.init(player,canSelect)
	add_child(ins)
	ins.connect("selectPlayer",getSelectPlayer)

func getSelectPlayer(player):
	players.append(player)
	print(players)
	
