extends Node
class_name LevelLoader

@export var default_level : Level

var curr_level : Node2D
var curr_level_res : Level
var curr_level_seg : LevelSegment

func _ready():
	load_level(default_level)

func load_level(l : Level, segment = 0, reloading : bool = false):
	if curr_level != null:
		unload_current_level()
	
	var loaded_level = l.scene.instantiate()
	add_child(loaded_level)
	
	curr_level = loaded_level
	curr_level_res = l
	change_segment(get_level_segment(segment), false, not reloading)
	
	GameMan.player.global_position = curr_level_seg.player_start_point.global_position
	GameMan.player.reset()
	
	GameMan.player.spotted = false
	
	GameMan.camera.zoom = Vector2.ONE * 2.5
	GameMan.camera.set_limit_to_curr_segment_bounds()

func reload_level(fade_anim : bool = false):
	if fade_anim:
		GameMan.screen_fade.fade_screen_out_in(0.5, 0.75)
		await GameMan.screen_fade.in_out_fade_halfway
	
	load_level(curr_level_res, curr_level_seg.segment_id, true)

func unload_current_level():
	curr_level.queue_free()
	
	curr_level = null
	curr_level_res = null

func get_level_segment(id) -> LevelSegment:
	for seg in get_tree().get_nodes_in_group("LevelSegment"):
		if seg is not LevelSegment:
			continue
		if seg.level != curr_level:
			continue
		
		if seg.segment_id == id:
			return seg
	return null

func change_segment(to : LevelSegment, pan_camera : bool = false, show_label : bool = false):
	curr_level_seg = to
	
	if pan_camera:
		GameMan.camera.trans_to_limits(GameMan.camera.get_limits_from_bounds(to.bounds), 5.0)
		if show_label:
			await GameMan.camera.transition_complete
			GameMan.segment_label.show_text(curr_level_seg.segment_name)
	elif show_label:
		GameMan.segment_label.show_text(curr_level_seg.segment_name)
		
