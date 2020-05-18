extends Sprite

export var number_of_frames = 1

func _ready() -> void:
    frame = randi() % number_of_frames
