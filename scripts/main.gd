extends Node2D
@export var playerScene:PackedScene
var point = 0

func _ready():
	add_to_group("system")
	add_to_group("moving")
	add_to_group("network")

func _process(delta):
	pass

func on_genCelled():
	spwanPlayer()

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
	endTrun()

func on_getLadder(p):
	p.ladder = $pathLadder

func endTrun():
	GameController.server_roll.rpc()
	await get_tree().create_timer(0.2).timeout
	point = GameController.point
	
	GameController.server_getEndTurn.rpc()
	get_tree().call_group("moving","on_walkToStep",point,1)
	$ui/point.text = str(point)
	$ui/roll.disabled = true
	$trunTimeout.stop()

func on_isTrun():
	$trunTimeout.start()
	$ui/roll.disabled = false

func _on_trun_timeout_timeout():
	endTrun()
