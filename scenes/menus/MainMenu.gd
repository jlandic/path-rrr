extends Control

func _ready() -> void:
    GameData.load_user_config()
    MusicPlayer.play()

func _on_RegisterButton_pressed() -> void:
    get_tree().change_scene("res://scenes/menus/RegisterScreen.tscn")

func _on_LoginButton_pressed() -> void:
    get_tree().change_scene("res://scenes/menus/LoginScreen.tscn")
