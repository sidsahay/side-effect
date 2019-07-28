extends KinematicBody


signal enemy_hit(body)
signal play_animation_looping(anim_name)
signal play_animation_oneshot(anim_name)


export var speed = 8
export var gravity = 300
const UP = Vector3(0, 1, 0)

var can_move = true
var motion_direction = Vector3(0, 0, 0)
var y_rotation = 0.0

enum PlayerState {
	IDLE,
	RUNNING,
	USING_ABILITY, 
	DYING, 
	DEAD
}

var state = PlayerState.IDLE
var state_has_changed = false
var motion_states_locked = false

func change_state_raw(new_state):
	state = new_state
	state_has_changed = true


func is_motion_state(some_state):
	return some_state == PlayerState.IDLE || some_state == PlayerState.RUNNING


func can_change_state(new_state):
	return not (motion_states_locked && is_motion_state(new_state))


func update_state(new_state):
	if state != new_state and can_change_state(new_state):
		change_state_raw(new_state)
	else:
		state_has_changed = false


func freeze_state():
	state_has_changed = false


func update_motion_direction_2d(new_motion_direction):
	motion_direction.x = new_motion_direction.x
	motion_direction.z = new_motion_direction.y
	
	
func update_motion_direction_xz(new_motion_direction):
	motion_direction.x = new_motion_direction.x
	motion_direction.z = new_motion_direction.z
	
	
func update_rotation_y(new_y_rotation):
	y_rotation = new_y_rotation


func apply_gravity():
	if is_on_floor():
		motion_direction.y = 0
	elif is_on_ceiling():
		motion_direction.y = -gravity
	else:
		motion_direction.y -= gravity


func move():
	self.set_rotation(Vector3(0, y_rotation, 0))
	move_and_slide(motion_direction.rotated(UP, deg2rad(45)) * speed, UP)


func _physics_process(delta):
	apply_gravity()
	if not motion_states_locked:
		move()
	if state_has_changed:
		match state:
			PlayerState.IDLE:
				emit_signal("play_animation_looping", "Idle-loop")
			PlayerState.RUNNING:
				emit_signal("play_animation_looping", "Run-loop")
			PlayerState.USING_ABILITY:
				motion_states_locked = true
				emit_signal("play_animation_oneshot", "Hit")
			PlayerState.DYING:
				motion_states_locked = true
				emit_signal("play_animation_oneshot", "Fall")
		freeze_state()


func _on_Weapon_body_entered(body):
	if body != self and motion_states_locked:
		emit_signal("enemy_hit", body)

func _on_AnimationController_oneshot_done():
	motion_states_locked = false
	change_state_raw(PlayerState.IDLE)