extends Spatial

const CAMERA_OFFSET = Vector3(15, 20, 15)

signal die

func _physics_process(delta):
	$Camera.translation = $HumanInputController/Player.translation + CAMERA_OFFSET


func _on_Player_enemy_hit():
	emit_signal("die")
