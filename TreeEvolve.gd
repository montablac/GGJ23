extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_tree().get_root().find_node("Player", true, false)
	player.connect("Change_World", self, "Evolve")
	print("tree hooked")

func Evolve(passes):
	var tree = find_node("tree")
	var seedling = find_node("seedling")
	var sapling = find_node("sapling")
	
	print("tree changed")
	
	if(passes == 1):
		tree.visible = false
		sapling.visible = true
	
	if(passes == 2):
		sapling.visible = false
	
	if(passes == 3):
		seedling.visible = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
