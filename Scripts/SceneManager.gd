extends Node

func go_to(path: String) -> void:
	get_tree().change_scene_to_file(path)
