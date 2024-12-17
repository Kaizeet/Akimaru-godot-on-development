extends Area2D

@export var is_final_door = false
@export var target_scene : String = ""

func _on_body_entered(body):
	if body and body.name == "Player":
		if is_final_door:
			_exit_game()
		elif target_scene != "":
			_change_scene(target_scene)

func _change_scene(scene_path):
	if ResourceLoader.exists(scene_path):
		print("Berpindah ke scene:", scene_path)
		get_tree().change_scene(scene_path)
	else:
		print("Error: Scene tidak ditemukan di path:", scene_path)

func _exit_game():
	print("Game selesai! Keluar dari aplikasi.")
	get_tree().quit()
