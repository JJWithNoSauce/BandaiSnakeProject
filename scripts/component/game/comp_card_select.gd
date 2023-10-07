extends Area2D

signal isActivate(act)
var isUsing = false
var isIncard = false

func _ready():
	add_to_group("cardSelect")

func _process(delta):
	pass

func _on_mouse_entered():
	isIncard = true

func _on_mouse_exited():
	isIncard = false

func _input(event):
	if isIncard and event.is_action_pressed("click"):
		get_tree().call_group("cardSelect","activate")

func activate():
	if not isIncard : 
		isUsing = false
		isActivate.emit(isUsing)
		return
	
	isUsing = !isUsing
	isActivate.emit(isUsing)
