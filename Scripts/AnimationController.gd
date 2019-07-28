extends Node

signal oneshot_done

var oneshot_anim_name = ""


func _on_Player_play_animation_looping(anim_name):
	get_node("../AnimationPlayer").play(anim_name, 0.1)


func _on_Player_play_animation_oneshot(anim_name):
	get_node("../AnimationPlayer").play(anim_name, 0.1)
	oneshot_anim_name = anim_name


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == oneshot_anim_name: 
		emit_signal("oneshot_done")
		oneshot_anim_name = ""
