extends Node2D
@export var playerScene:PackedScene
var point = 0
var reqPoint = 0
var isWalkRoll = false
var walkInRoll = 1
var turn = 0

func _ready():
	$bgm.play()
	add_to_group("system")
	add_to_group("moving")
	add_to_group("network")
	add_to_group("card")

func _process(delta):
	pass

func on_genCelled():
	spwanPlayer()
	await  Lib.wait(0.5)
	ActionControl.setNowPlayer(Lib.getUID())

func spwanPlayer():
	if not multiplayer.is_server() : return
	var players = GameController.players
	for i in players:
		var ins = playerScene.instantiate()
		var pos = get_node("pathLadder").getPosFromStep(1)
		ins.init(pos,players[i],i,$pathLadder,1)
		$players.add_child(ins,true)
	
	if Lib.isServer(): GameController.readyToStart()

func _on_roll_pressed():
	endTurn()

func on_getLadder(p):
	p.ladder = $pathLadder

func endTurn():
	$dice.play()
	await Lib.wait(1)
	GameController.server_roll.rpc(reqPoint)
	await Lib.wait(0.2)
	point = GameController.point
	reqPoint = 0
	$ui/roll.disabled = true
	$trunTimeout.stop()
	$ui/point.text = str(point)
	isWalkRoll = true
	
	if walkInRoll-1: $ui/point.text = str(point) + " * " + str(walkInRoll)
	point = point * walkInRoll
	get_tree().call_group("moving","on_walkToStep",point,1)
	walkInRoll = 1

func on_walked():
	if not isWalkRoll : return
	isWalkRoll = false
	GameController.server_getEndTurn.rpc()
	get_tree().call_group("network","on_endTurn")

func on_isTurn():
	$trunTimeout.start()
	turn += 1
	if turn%2 == 0: $cardContainer.draw()
	$ui/roll.disabled = false

func _on_trun_timeout_timeout():
	endTurn()

func on_winned():
	var win = load("res://scene/ui/winning.tscn")
	get_tree().change_scene_to_packed(win)

func on_setWalkInRoll(mu):
	walkInRoll = mu
	$ui/point.text = str(point) + " * " + str(walkInRoll)
