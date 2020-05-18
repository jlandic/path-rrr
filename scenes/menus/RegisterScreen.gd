extends Control

onready var http = $HTTPRequest
onready var storeHttp = $CreateUserInfo
onready var username = $VBoxContainer/Username/LineEdit
onready var nickname = $VBoxContainer/Nickname/LineEdit
onready var lucky_number = $VBoxContainer/LuckyNumber/LineEdit
onready var password = $VBoxContainer/Password/LineEdit
onready var confirmation = $VBoxContainer/PasswordConfirm/LineEdit
onready var notification = $VBoxContainer/Notification

func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    var response_body = JSON.parse(body.get_string_from_ascii())
    if response_code != 200:
        notification.text = response_body.result.error.message.capitalize()
    else:
        notification.text = "Creating profile. Please wait..."
        GameData.data.email = username.text
        GameData.save_user_config()

func _on_Button_pressed() -> void:
    if password.text != confirmation.text or username.text.empty() or password.text.empty():
        notification.text = "Invalid password or username"
        return
    if nickname.text.empty() or lucky_number.text.empty():
        notification.text = "Please specify a nickname and a lucky number"

    Firebase.register(
        username.text,
        password.text,
        nickname.text,
        lucky_number.text,
        http,
        storeHttp
    )

func _on_CreateUserInfo_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
    var response_body = JSON.parse(body.get_string_from_ascii())
    if response_code != 200:
        notification.text = response_body.body.result.error.message.capitalize()
    else:
        notification.text = "Registration successful!"
        yield(get_tree().create_timer(2.0), "timeout")
        get_tree().change_scene("res://scenes/menus/LoginScreen.tscn")

