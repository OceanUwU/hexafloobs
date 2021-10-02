extends Control

signal ready_to_start

const APPEAR_TIME = 2.0

func _ready():
    self.modulate.a = 0

func show():
    $Tween.interpolate_property(self, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), APPEAR_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()
    yield($Tween, 'tween_completed')
    emit_signal('ready_to_start')

func start_game():
    if self.modulate.a > 0:
        $Tween.interpolate_property(self, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), APPEAR_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $Tween.start()
