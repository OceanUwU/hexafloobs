extends Area2D

signal touch_floor

const MAX_WING_ROTATION = 0.06 * PI
const WING_FLAP_SPEED = 1.57 * PI
const MIN_COLOR_BRIGHTNESS = 0.02

var value
var wings
var speed = 0
var wing_direction = 1
var wing_rotation = 0

func _ready():
    wings = [$LeftWing, $RightWing]
    var rng = RandomNumberGenerator.new()
    rng.randomize()
    value = rng.randi_range(1, 255)
    $Display/Label.text = Globals.convert_to_hex(value)
    $Color.modulate = Color(rng.randf_range(MIN_COLOR_BRIGHTNESS, 1), rng.randf_range(MIN_COLOR_BRIGHTNESS, 1), rng.randf_range(MIN_COLOR_BRIGHTNESS, 1), 1)

func init(new_speed):
    speed = new_speed

func _process(delta):
    wing_rotation += wing_direction * WING_FLAP_SPEED * delta
    if abs(wing_rotation) > MAX_WING_ROTATION:
        wing_rotation = wing_direction * MAX_WING_ROTATION
        wing_direction *= -1
    for i in range(len(wings)):
        wings[i].rotation = wing_rotation * (i * 2 - 1)

func _physics_process(delta):
    self.position.y += speed * delta


func _on_Area2D_area_shape_entered(_area_id, _area, _area_shape, _local_shape):
    if position.y < 0:
        return
    $CollisionShape2D.set_deferred('disabled', true)
    emit_signal('touch_floor')
