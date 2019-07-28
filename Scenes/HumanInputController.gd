extends Node

var player
var mouse_base_point = Vector2(0, 0)
var input_is_dragging = false
const ROT_OFFSET = Vector2(-cos(3.1415/4), sin(3.1415/4))

func _ready():
	player = $Player


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			input_is_dragging = event.pressed
			mouse_base_point = event.position
	elif event is InputEventMouseMotion:
		if input_is_dragging:
			var temp = (event.position - mouse_base_point).normalized()
			player.update_motion_direction_2d(temp)
			player.update_rotation_y(temp.angle_to(ROT_OFFSET))
			player.update_state(player.PlayerState.RUNNING)
		else:
			player.update_motion_direction_2d(Vector2(0, 0))
			player.update_state(player.PlayerState.IDLE)

	if Input.is_action_just_pressed("ui_accept"):
		player.update_state(player.PlayerState.USING_ABILITY)