extends Node2D

signal activated
signal change_value(value)

const BIT_WIDTH = 50
const BIT_Y = 665
const BIT_ACTIVATE_INTERVAL = 0.2

export (PackedScene) var Bit

var bits = []
var value = 0

func _ready():
    for i in range(8):
        var bit = Bit.instance()
        bit.init(8-i-1)
        bit.position = Vector2(BIT_WIDTH * i, BIT_Y)
        add_child(bit)
        bit.connect('change_value', self, '_on_Bit_change_value')
        bits.append(bit)

func _on_Scientist_activate():
    for bit in bits:
        bit.activate()
        yield(get_tree().create_timer(BIT_ACTIVATE_INTERVAL), 'timeout')
    $Value.show()
    emit_signal('activated')

func reset():
    for bit in bits:
        bit.set_on(false, false)
    _on_Bit_change_value()

func start_game():
    for bit in bits:
        bit.start_game()
    $Scientist.start_game()

func end_game():
    for bit in bits:
        bit.end_game()
    $Scientist.end_game()

func _on_Bit_change_value():
    value = 0
    for bit in bits:
        value += int(bit.on) << bit.bit_index
    $Value.text = Globals.convert_to_hex(value)
    emit_signal('change_value', value)
