extends CharacterBody2D
class_name Player

var info
var ladder:Ladder
var isWalk = false
var uid = 0
var stepNow = 1
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
	
	addName()
	ActionControl.playersStat[str(name).to_int()] = self
	$Polygon2D.color = Color(info["id"]/4.0,info["id"]/5.0,info["id"]/6.0)
	
	if info["id"] == 1:
		$pSprite.frame = 0
	elif info["id"] == 2:
		$pSprite.frame = 1
	elif info["id"] == 3:
		$pSprite.frame = 2
	elif info["id"] == 4:
		$pSprite.frame = 3

func addName():
	$name.text = info["name"]
	var pos = Vector2(0,0).from_angle((info["id"]-1)*45) * 15
	print(pos)
	$name.position = pos

func _physics_process(delta):
	if not isSelf(): return
	if isWalk : position = position.move_toward(nextPos,10)

func on_walkToStep(s,dir):
	isWalk = true
	stepNow += 1 * dir
	nextPos = ladder.getPosFromStep(stepNow)
	await Lib.wait(0.2)
	if ladder.step != stepNow : 
		if s > 1 : 
			on_walkToStep(s-1,dir)
		else : 
			get_tree().call_group("system","on_walked")
			isWalk = false
		return
	
	if s > 0 : on_walkToStep(s-1,-dir)
	else : 
		get_tree().call_group("system","on_winned")

func setStep(s):
	var pos = ladder.getPosFromStep(s)
	nextPos = pos
	stepNow = s
	position = pos

func reqPoint(p):
	get_parent().reqPoint = p

func swapPos(p:Player):
	var pos = p.position
	p.position = position
	position = pos

func isSelf():
	return $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

