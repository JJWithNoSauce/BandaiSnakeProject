extends Node2D
@export var playerScene:PackedScene
var point = 0

func _ready():
	add_to_group("system")
	add_to_group("moving")

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

func _on_roll_pressed():
	GameController.server_roll.rpc()
	await get_tree().create_timer(0.2).timeout
	point = GameController.point
	
	$ui/point.text = str(point)
	get_tree().call_group("moving","on_walkToStep",point,1)

func on_getLadder(p):
	p.ladder = $pathLadder
