extends Control

onready var http = $HTTPRequest
onready var username = $VBoxContainer/Email
onready var password = $VBoxContainer/Password
onready var notification = $VBoxContainer/Notification

func _ready() -> void:
    username.text = GameData.data.email

func _on_Login_pressed() -> void:
    if username.text.empty() or password.text.empty():
        notification.text = "Please enter your email and password"
        return
    Firebase.login(username.text, password.text, http)
    GameData.data.email = username.text
    GameData.save_user_config()

func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
    var response_body = JSON.parse(body.get_string_from_ascii())
    if response_code != 200:
        notification.text = response_body.result.error.message.capitalize()
    else:
        notification.text = "Sign in successful!"
        get_tree().change_scene("res://scenes/game/TestGameScene.tscn")

func _on_BackButton_pressed() -> void:
    get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
