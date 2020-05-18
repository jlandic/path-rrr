extends Node2D

const QUEST_FILE_PATH = "res://config/path.json"

var config = {}

func _ready() -> void:
    if _load_config():
        _load_user_profile()

func _load_quest(
    quest: Dictionary,
    quest_index: int,
    seed_number: int,
    player_room_index: int
) -> void:
    $DungeonGenerator.generate(quest, quest_index, seed_number)
    var player_position = $DungeonGenerator.get_start_position_for_room(player_room_index)
    $Player.position = player_position
    MusicPlayer.stop()

func _load_config() -> bool:
    var path_file = File.new()
    path_file.open(QUEST_FILE_PATH, File.READ)
    
    var json = JSON.parse(path_file.get_as_text())
    
    if json.error == OK:
        config = json.result
        
        return true
    else:
        print("Error: ", json.error)
        print("Error Line: ", json.error_line)
        print("Error String: ", json.error_string)

        return false

func _load_user_profile() -> void:
    Firebase.get_document("users/%s" % Firebase.user_info.id, $HTTPRequest)

func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
    var result_body = JSON.parse(body.get_string_from_ascii()).result as Dictionary
    match response_code:
        404:
            get_tree().change_scene("res://scenes/menus/LoginScreen.tscn")
        200:
            _set_profile(result_body.fields)
            _load_quest(
                config.quests[GameData.profile.quest_index],
                GameData.profile.quest_index,
                GameData.profile.seed,
                GameData.profile.room_index
            )

func _set_profile(fields: Dictionary) -> void:
    GameData.profile = {
        "seed": int(fields.seed.integerValue),
        "quest_index": int(fields.quest_index.integerValue),
        "room_index": int(fields.room_index.integerValue),
        "nickname": fields.nickname.stringValue
    }
