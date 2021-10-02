extends Node

const INITIAL_TIMER_SPEED = 4.5
const FINAL_TIMER_SPEED = 1.5
const TIMER_INCREASE = FINAL_TIMER_SPEED - INITIAL_TIMER_SPEED
const INITIAL_FLOOB_SPEED = 30.0
const FINAL_FLOOB_SPEED = 80.0
const SPEED_INCREASE = FINAL_FLOOB_SPEED - INITIAL_FLOOB_SPEED
const HARDEST_DIFFICULTY = 100.0 #at this score, floob speed will be final_floob_speed and timer speed will be final_timer_speed

const BULLET_SHOOT_TIME = 0.2
const FLASH_TIME = 0.4
const HIDE_DEATHMENU_TIME = 0.5

export (PackedScene) var Floob
export (PackedScene) var Bullet
export (PackedScene) var DeathParticles
var playing = false
var ready_to_start = false
var floobs = []
var score = 0

func _input(event):
    if ready_to_start && !playing && (event is InputEventKey || event is InputEventMouseButton):
        start_game()
    
func start_game():
    score = 0
    floobs = []
    playing = true
    $ControlArea.start_game()
    $StartMenu.start_game()
    $FloobTimer.wait_time = INITIAL_TIMER_SPEED
    $FloobTimer.start()
    _on_FloobTimer_timeout()
    $Cannon/ShootyPart.rotation = 0
    
    if $DeathMenu.visible:
        $DeathMenu/Tween.interpolate_property($DeathMenu, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), HIDE_DEATHMENU_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $DeathMenu/Tween.start()

func _on_ControlArea_activated():
    $StartMenu.show()

func _on_StartMenu_ready_to_start():
    ready_to_start = true

func _on_FloobTimer_timeout():
    var difficulty = float(min(score, HARDEST_DIFFICULTY)) / HARDEST_DIFFICULTY
    var timer_speed = INITIAL_TIMER_SPEED + TIMER_INCREASE * difficulty
    var floob_speed = INITIAL_FLOOB_SPEED + SPEED_INCREASE * difficulty
    
    $FloobTimer.wait_time = timer_speed
    var floob = Floob.instance()
    floob.init(floob_speed)
    floobs.append(floob)
    add_child(floob)
    $FloobPath/FloobSpawnLocation.offset = randi()
    floob.position = $FloobPath/FloobSpawnLocation.position
    floob.connect('touch_floor', self, '_on_Floob_touch_floor')

func update_score():
    $ControlArea/Score.text = str(score)

func _on_ControlArea_change_value(value):
    for i in range(len(floobs)):
        var floob = floobs[i]
        if floob.value == value:
            $ControlArea.reset()
            floobs.remove(i)
            floob.get_node('CollisionShape2D').set_deferred('disabled', true)
            $Cannon/ShootyPart.rotation = -atan(($Cannon.position.x - floob.position.x) / ($Cannon.position.y - floob.position.y))
            
            var bullet = Bullet.instance()
            bullet.get_node('Label').text = Globals.convert_to_hex(value)
            bullet.rotation = $Cannon/ShootyPart.rotation
            add_child(bullet)
            $Shoot.play()
            var tween = bullet.get_node('Tween')
            tween.interpolate_property(bullet, 'position', $Cannon.position, floob.position, BULLET_SHOOT_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
            tween.start()
            yield(tween, 'tween_completed')
            
            var particles = DeathParticles.instance()
            add_child(particles)
            particles.color = floob.get_node('Color').modulate
            particles.position = floob.position
            particles.emitting = true
            $Camera2D.shake(0.2, 100, 8)
            $Hit.play()
            
            bullet.queue_free()
            floob.queue_free()
            
            if playing:
                score += 1
                update_score()
            
            yield(get_tree().create_timer(particles.lifetime), 'timeout')
            particles.queue_free()
            
            break

func _on_Floob_touch_floor():
    game_over()

func game_over():
    $FloobTimer.stop()
    $ControlArea.reset()
    for floob in floobs:
        floob.queue_free()
    floobs = []
    playing = false
    ready_to_start = false
    $ControlArea/Best.update_best(score)
    score = 0
    update_score()
    $ControlArea.end_game()
    $DeathMenu.visible = true
    $DeathMenu.modulate.a = 1
    $Camera2D.shake(FLASH_TIME, 100, 20)
    $Lose.play()
    $Flash/White/Tween.interpolate_property($Flash/White, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), FLASH_TIME, Tween.TRANS_SINE, Tween.EASE_IN)
    $Flash/White/Tween.start()
    yield($Flash/White/Tween, 'tween_completed')
    ready_to_start = true
