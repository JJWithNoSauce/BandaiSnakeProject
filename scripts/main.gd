extends Node2D
@export var playerScene:PackedScene
var point = 0
var reqPoint = 0
var isWalkRoll = false

func _ready():
	add_to_group("system")
	add_to_group("moving")
	add_to_group("network")

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
	GameController.server_roll.rpc(reqPoint)
	await Lib.wait(0.2)
	point = GameController.point
	
	get_tree().call_group("moving","on_walkToStep",point,1)
	
	reqPoint = 0
	$ui/point.text = str(point)
	$ui/roll.disabled = true
	$trunTimeout.stop()
	isWalkRoll = true
	

func on_walked():
	if not isWalkRoll : return
	isWalkRoll = false
	GameController.server_getEndTurn.rpc()
	get_tree().call_group("network","on_endTurn")

func on_isTurn():
	$trunTimeout.start()
	$ui/roll.disabled = false

func _on_trun_timeout_timeout():
	endTurn()
