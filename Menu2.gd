extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var xRatio = $"."["rect_size"][0] / 1882
	var yRatio = $"."["rect_size"][1]  / 751
	
	$Background["scale"] = Vector2(xRatio,yRatio)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Control_resized():
	var xRatio = $"."["rect_size"][0] / 1882
	var yRatio = $"."["rect_size"][1]  / 751
	
	$Background["scale"] = Vector2(xRatio,yRatio)
