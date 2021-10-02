extends Node2D

signal activate

const WALK_TIME = 3.0

func _ready():
    $Sprite.playing = true
    $Sprite.animation = 'walking'
    $Tween.interpolate_property($Sprite, 'position', Vector2(0, 0), Vector2(154, 0), WALK_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
    $Tween.start()
    yield($Tween, 'tween_completed')
    $Sprite.playing = false
    $Sprite.animation = 'idle'
    emit_signal('activate')

func start_game():
    $Sprite.animation = 'idle'

func end_game():
    $Sprite.animation = 'sad'
