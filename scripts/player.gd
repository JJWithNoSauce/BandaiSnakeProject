extends CharacterBody2D
class_name Player

var info
var ladder:Ladder
var isWalk = false
var uid = 0
var stepWalk = 0
var stepNow = 1
var stepDir = 1
var nextPos = Vector2(0,0)

func init(pos,playerInfo,n,l,now):
	name = str(n)
	nextPos = pos
	ladder = l
	stepNow = now
	info = GameController.players[str(name).to_int()]

func _enter_tree():
	uid = str(name).to_int()
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _ready():
	add_to_group("moving")
	add_to_group("system")
	
	get_tree().call_group("system","on_getLadder",self)
	info = GameController.players[str(name).to_int()]
	nextPos = ladder.getPosFromStep(1)
	position = nextPos
	
	GameController.playersStat.append(self)
	$Polygon2D.color = Color(info["id"]/4.0,info["id"]/5.0,info["id"]/6.0)

func _physics_process(delta):
	if not isSelf(): return
	if stepWalk : position = position.move_toward(nextPos,10)

func on_walkToStep(s,dir):
	stepWalk = s
	stepDir = dir
	stepNow += 1 * dir
	stepWalk -= 1 
	nextPos = ladder.getPosFromStep(stepNow)
	
	await Lib.wait(0.4)
	if ladder.step != stepNow : 
		if stepWalk : on_walkToStep(stepWalk,stepDir)
		return
	
	if stepWalk > 0 : stepDir = -1
	else : 
		stepWalk = 0
		get_tree().call_group("system","on_winned")

func setStep(s):
	var pos = ladder.getPosFromStep(s)
	position = pos

func reqPoint(p):
	get_parent().reqPoint = p

func swapPos(p:Player):
	var pos = p.position
	p.position = position
	position = pos

func isSelf():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

