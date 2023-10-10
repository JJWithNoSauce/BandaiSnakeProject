extends Node2D
class_name CompActionWalk

@export var walkStep = 0
@export var dir = 1

func _ready():
	pass 

func _process(delta):
	pass

func walkingStep(player,step,dir):
	ActionControl.server_on_setWalk.rpc(player.uid,step,dir)
	
func walking(player):
	ActionControl.server_on_setWalk.rpc(player.walkStep,dir)
