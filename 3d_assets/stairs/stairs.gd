extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var Player = get_tree().get_root().find_node("Player", true, false)
	Player.connect("Change_World",self,"Vanish")

func Vanish(passes):
	if(passes == 1):
		$"."["visible"] = false
		$Area/["monitoring"] = false
		$Area/["monitorable"] = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
