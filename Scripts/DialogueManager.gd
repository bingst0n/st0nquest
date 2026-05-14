extends Node

const DIALOGUE_SCENE = preload("res://Scenes/Objects/dialogue_system.tscn")

var is_open := false
var _instance: Node = null
var _speakers: Dictionary = {}

func register_speaker(id: String, data: Dictionary) -> void:
	_speakers[id] = data

func show_dialogue(speaker, text: String) -> void:
	if not is_open:
		is_open = true
		_set_player_movement(false)
		_instance = DIALOGUE_SCENE.instantiate()
		get_tree().current_scene.add_child(_instance)
		var speaker_data = {} if speaker == null else _speakers.get(speaker, {})
		_instance.start(speaker_data, text)
		_instance.dialogue_finished.connect(_on_finished, CONNECT_ONE_SHOT)

func _on_finished() -> void:
	is_open = false
	if _instance:
		_instance.queue_free()
		_instance = null
	_set_player_movement.call_deferred(true)

func _set_player_movement(enabled: bool) -> void:
	for player in get_tree().get_nodes_in_group("players"):
		player.set_physics_process(enabled)
