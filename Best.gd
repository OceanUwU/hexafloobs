extends Label

var best

func _ready():
    var best_file = File.new()
    best_file.open('user://best.dat', File.READ)
    best = int(best_file.get_as_text())
    
    update_best(best)

func update_best(score):
    best = max(score, best)
    text = 'Best: '+str(best)
    
    var best_file = File.new()
    best_file.open('user://best.dat', File.WRITE)
    best_file.store_string(str(best))
