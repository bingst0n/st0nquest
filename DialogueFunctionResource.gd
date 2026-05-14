extends Resource
class_name DialogueFunction

@export var speaker_img: Texture
@export var speaker_img_Hframes: int = 1
@export var speaker_img_rest_frame: int = 0

@export_multiline var text: String

@export var choice_text: Array[String]
@export var choice_function_cell: Array[DialogueFunction]
