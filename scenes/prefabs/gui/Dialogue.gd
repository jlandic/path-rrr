extends Control
class_name Dialogue

var dialogue = []
var dialogue_index = 0
var finished = false
var in_dialogue = false

onready var label = $DialogueBox/RichTextLabel
onready var label_tween = $DialogueBox/Tween

signal dialogue_over

func _ready() -> void:
    _reset()

func start(lines: Array) -> void:
    dialogue = lines
    dialogue_index = 0
    $DialogueBox.visible = true
    in_dialogue = true
    
    _next()

func _process(_delta: float) -> void:
    if in_dialogue and (Input.is_action_just_pressed("interact") or \
        Input.is_action_just_pressed("ui_accept")):
        _next()
    elif in_dialogue and Input.is_action_just_pressed("escape"):
        _finish()

func _next() -> void:
    $DialogueBox/NextIcon.visible = false
    if label.percent_visible != 1:
        label_tween.stop(label, "percent_visible")
        label.percent_visible = 1
        $DialogueBox/NextIcon.visible = true
    elif dialogue_index < dialogue.size():
        label.bbcode_text = dialogue[dialogue_index]
        label.percent_visible = 0
        label_tween.interpolate_property(
            label,
            "percent_visible",
            0,
            1,
            1,
            Tween.TRANS_LINEAR,
            Tween.EASE_IN_OUT
        )
        label_tween.start()
        dialogue_index += 1
    else:
        _finish()

func _finish() -> void:
    _reset()
    emit_signal("dialogue_over")

func _reset() -> void:
    $DialogueBox.visible = false
    in_dialogue = false

func _on_Tween_tween_completed(object: Object, _key: NodePath) -> void:
    if object == label:
        $DialogueBox/NextIcon.visible = true
