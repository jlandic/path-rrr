extends StaticBody2D

var unlocked = true
var save_on_open = false

var quest_index
var room_index

func open():
    if unlocked:
        $Sprite.frame = 1
        remove_child($CollisionShape2D)

func set_save_on_open(quest_index, room_index) -> void:
    self.quest_index = quest_index
    self.room_index = room_index
    self.save_on_open = true

func _on_Area2D_body_entered(body: Node) -> void:
    if body.is_in_group("Player"):
        open()
        if save_on_open:
            GameData.start_new_room(room_index, $HTTPRequest)

func _on_HTTPRequest_request_completed(_result: int, response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
    var response_body = JSON.parse(body.get_string_from_ascii())
    if response_code != 200:
        print(response_body.result.error.message)
    else:
        print("Game saved...")
