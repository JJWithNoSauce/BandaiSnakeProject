extends Node

var playersStat = {}
var nowPlayer : Player

func _ready():
	add_to_group("card")

func setNowPlayer(id):
	nowPlayer = playersStat[id]

@rpc("any_peer","call_local","reliable",3)
func server_on_setWalk(id,step,dir):
	if not Lib.isServer() : return
	on_getWalk.rpc_id(id,step,dir)
	
@rpc("authority","call_local","reliable",3)
func on_getWalk(step,dir):
	nowPlayer.on_walkToStep(step,dir)

@rpc("any_peer","call_local","reliable",3)
func server_on_walkInRoll(id,mult):
	if not Lib.isServer() : return
	getWalkInRoll.rpc_id(id,mult)

@rpc("authority","call_local","reliable",3)
func getWalkInRoll(mult):
	get_tree().call_group("card","on_setWalkInRoll",mult)
