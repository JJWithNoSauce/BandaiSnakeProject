extends Node2D

var isMouse = false
var player:Player
var isCanSelect = true
var isSelect = false
var isFirst = false

signal selectPlayer(player)

func init(p,can):
	player = p
	isCanSelect = can
	
func _ready():
	add_to_group("card")
	add_to_group("aimming")
	global_scale = Vector2(1,1)
	if not isCanSelect :
		$Polygon2D.visible = false
		$Polygon2D2.visible = true
	

func _process(delta):
	if not isFirst :
		isFirst = true
		global_position = player.global_position

func _on_hitbox_mouse_entered():
	isMouse = true

func _on_hitbox_mouse_exited():
	isMouse = false

func _input(event):
	if event.is_action_pressed("click") and isMouse and isCanSelect:
		get_tree().call_group("aimming","playerSelected")
		$Polygon2D.visible = false
		$Polygon2D2.visible = true
		isSelect = true
		
func playerSelected():
	if isSelect : return
	queue_free()
		
func on_useCard():
	if isSelect or not isCanSelect:
		selectPlayer.emit(player)
	queue_free()

func on_deActivate():
	queue_free()
