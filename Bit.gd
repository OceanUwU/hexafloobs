extends Area2D

signal change_value

const CONTROLS = [['L', KEY_L], ['K', KEY_K], ['J', KEY_J], ['H', KEY_H], ['F', KEY_F], ['D', KEY_D], ['S', KEY_S], ['A', KEY_A]]
const OFF_TEXTURE = preload('res://assets/bitoff.png')
const ON_TEXTURE = preload('res://assets/biton.png')

var bit_index
var playing = false
var on = false
var flipped_this_drag = false
var mouse_down = false

func init(new_bit_index):
    bit_index = new_bit_index
    $Sprite/ControlDisplay.text = CONTROLS[bit_index][0]

func activate():
    set_on(false, false)
    $Sprite/ControlDisplay.show()

func start_game():
    yield(get_tree().create_timer(0.1), 'timeout')
    playing = true

func _input(event):
    if event is InputEventMouseButton:
        mouse_down = event.pressed
        if mouse_down:
            flipped_this_drag = false
    if event is InputEventKey && event.pressed && event.scancode == CONTROLS[bit_index][1]:
        flip()

func _on_Area2D_input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton && mouse_down:
        flip()
        
func _on_Area2D_mouse_entered():
    if mouse_down && !flipped_this_drag:
        flip()

func flip():
    if playing:
        set_on(!on, true)
        flipped_this_drag = true

func set_on(now_on, emit):
    on = now_on
    if emit:
        emit_signal('change_value')
    $Sprite.texture = ON_TEXTURE if on else OFF_TEXTURE

func end_game():
    set_on(false, false)
    playing = false
