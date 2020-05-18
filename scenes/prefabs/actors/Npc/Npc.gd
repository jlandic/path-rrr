extends StaticBody2D
class_name Npc

var dialogue
var in_dialogue = false

func _on_Area2D_body_entered(body: Node) -> void:
    if body.is_in_group("Player"):
        body.set_target(self)

func _on_Area2D_body_exited(body: Node) -> void:
    if body.is_in_group("Player"):
        body.unset_target()
        
func _on_Dialogue_dialogue_over() -> void:
    in_dialogue = false

func activate() -> void:
    if !in_dialogue:
        in_dialogue = true
        $CanvasLayer/Dialogue.start(dialogue)
