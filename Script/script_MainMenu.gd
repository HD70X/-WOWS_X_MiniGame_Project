extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/LevelChoiceButton.pressed.connect(_on_level_choice_button_pressed)
	$VBoxContainer/SettingButton.pressed.connect(_on_setting_button_pressed)
	$VBoxContainer/ExitButton.pressed.connect(_on_exit_button_pressed)
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levelScene_level1.tscn")

func _on_level_choice_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/LevelChoiceMenu.tscn")

func _on_setting_button_pressed():
	get_tree().paused = true
	get_tree().paused = false

func _on_exit_button_pressed():
	get_tree().quit()
