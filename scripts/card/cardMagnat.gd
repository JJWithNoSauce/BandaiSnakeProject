extends CardParent

func _on_comp_select_all_in_range_select_player(players):
	for i in players :
		var step = ActionControl.nowPlayer.stepNow - i.stepNow
		if not step : return
		var dir = step/(abs(step))
		$CompActionWalk.walkingStep(i,abs(step),dir)
