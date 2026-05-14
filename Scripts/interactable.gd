extends Node2D

@export var dialogue_text: String = ""
@export var speaker: String = ""

func _ready() -> void:
	add_to_group("interactables")
