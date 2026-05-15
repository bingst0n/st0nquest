extends Node

const START_DELAY := 0.8

var _player: AudioStreamPlayer
var _target_path := ""

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)

func play_music(path: String) -> void:
	_target_path = path
	_player.stop()
	await get_tree().create_timer(START_DELAY).timeout
	if _target_path != path:
		return
	var stream := load(path) as AudioStreamMP3
	stream.loop = true
	_player.stream = stream
	_player.play()
