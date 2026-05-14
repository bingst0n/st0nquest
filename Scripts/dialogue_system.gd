extends CanvasLayer

signal dialogue_finished

@onready var _label: RichTextLabel = $Panel/HBoxContainer/VBoxContainer/RichTextLabel
@onready var _speaker_container: Control = $Panel/HBoxContainer/SpeakerMain
@onready var _sprite: Sprite2D = $Panel/HBoxContainer/SpeakerMain/Sprite2D
@onready var _audio: AudioStreamPlayer = $AudioStreamPlayer

const CHARS_PER_SECOND := 30.0

var _typing := false
var _tween: Tween
var _last_chars := 0

func start(speaker_data: Dictionary, text: String) -> void:
	_label.text = text
	_label.visible_characters = 0
	_last_chars = 0
	var texture = speaker_data.get("texture")
	_speaker_container.visible = texture != null
	_sprite.texture = texture
	_audio.stream = speaker_data.get("audio")

	var total := _label.get_total_character_count()
	_typing = true
	_tween = create_tween()
	_tween.tween_property(_label, "visible_characters", total, total / CHARS_PER_SECOND)
	_tween.tween_callback(func(): _typing = false)

func _process(_delta: float) -> void:
	if _typing:
		var current := _label.visible_characters
		if current != _last_chars:
			_last_chars = current
			if _audio.stream and current % 2 == 0:
				_audio.play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("run"):
		get_viewport().set_input_as_handled()
		if _typing:
			_tween.kill()
			_typing = false
			_label.visible_characters = -1
		else:
			dialogue_finished.emit()
