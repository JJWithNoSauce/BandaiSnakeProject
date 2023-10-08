extends Node2D
class_name CardParent

signal isActivate(act)
var activate = false

func init(pos):
	position = pos
	get_node("comp_card_select").connect("isActivate",on_getActivate)
	add_to_group("card")

func on_getActivate(p):
	if activate == p : return
	
	activate = p
	isActivate.emit(activate)
	var use = get_parent().get_node("useCard")
	
	if activate : 
		use.visible = true
		use.global_position.x = global_position.x - use.size.x/2
		position.y -= 50
	else : 
		use.visible = false
		get_tree().call_group("card","on_deActivate")
		position.y += 50
