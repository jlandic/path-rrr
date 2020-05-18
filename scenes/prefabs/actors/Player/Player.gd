extends KinematicBody2D
class_name Player

const SPEED = 100

var motion = Vector2(0, 0)
var sprite_direction = "Right"

var target: Npc

func set_target(npc: Npc) -> void:
    target = npc

func unset_target() -> void:
    target = null

func _physics_process(_delta: float) -> void:
    _process_input()
    _update_sprite_direction()
    _move()
    _update_animation()

func _process_input():
    var left = Input.is_action_pressed("move_left")
    var right = Input.is_action_pressed("move_right")
    var up = Input.is_action_pressed("move_up")
    var down = Input.is_action_pressed("move_down")

    motion.x = -int(left) + int(right)
    motion.y = -int(up) + int(down)
    
    if Input.is_action_just_pressed("interact"):
        target.activate()

func _move():
    var velocity = motion.normalized() * SPEED * scale
    move_and_slide(velocity, Vector2(0, 0))

func _update_animation():
    if motion == Vector2.ZERO:
        _switch_animation("Idle")
    else:
        _switch_animation("Walk")

func _update_sprite_direction():
    match motion:
        Vector2.LEFT: sprite_direction = "Left"
        Vector2.RIGHT: sprite_direction = "Right"
        Vector2.UP: sprite_direction = "Up"
        Vector2.DOWN: sprite_direction = "Down"

func _switch_animation(animation):
    var new_animation = str(animation, sprite_direction)
    
    if $AnimationPlayer.current_animation != new_animation:
        $AnimationPlayer.play(new_animation)
