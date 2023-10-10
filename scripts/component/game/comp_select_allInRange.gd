extends SelectParent

@export var stepRange = 1

func genSelect():
	var nowPlayer:Player = ActionControl.nowPlayer
	var allPlayer = ActionControl.playersStat
	
	for i in  allPlayer:
		var player = allPlayer[i]
		if player == nowPlayer: continue
		
		var delStep = nowPlayer.stepNow - player.stepNow
		if abs(delStep) <= stepRange:
			setTarget(player,false)
