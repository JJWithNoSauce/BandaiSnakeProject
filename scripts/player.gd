extends CharacterBody2D
var info
var ladder:Ladder
var isWalk = false
var stepWalk = 0
var stepNow = 1
var stepDir = 1

func init(pos,playerInfo,n,l,now):
	name = str(n)
	position = pos
	info = playerInfo
	ladder = l
	stepNow = now
	
func _enter_tree():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _ready():
	add_to_group("moving")
	add_to_group("system")
	get_tree().call_group("system","on_getLadder",self)

func _physics_process(delta):
	if isSelf() :
		if stepWalk : on_walkToStep(stepWalk,stepDir)

func on_walkToStep(s,dir):
	stepWalk = s
	stepDir = dir
	stepNow += 1 * dir
	stepWalk -= 1 
	var nextPos = ladder.getPosFromStep(stepNow)
	position = nextPos
	if ladder.step != stepNow : return
		
	if stepWalk > 0 : stepDir = -1
	else : 
		stepWalk = 0
		get_tree().call_group("system","on_winned")

func isSelf():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()
