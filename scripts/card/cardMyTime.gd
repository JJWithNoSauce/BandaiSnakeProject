extends CardParent


func _on_comp_select_self_select_player(players):
	for i in players:
		$comp_action_walkInRoll.walkInRoll(i,2)
