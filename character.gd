extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Speed = 5;
var Force = Vector3(0.0,0.0,0.0);
var JumpDirection = Vector3(0.0,0.0,0.0)
var JumpAmount = 0
var SavedDirection = 0
var Jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var Gravity = 1.0
	
	Force[1] -= Gravity
	Force = self.move_and_slide(Force,Vector3(0.0,1.0,0.0),true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var Direction = 0;
	var JumpPower = 20;
	var NotMoving = true
	var Gravity = 5.0
	var SlopeHelper = 1.0
	var slopepercentage = 0.5
	
	Force = Vector3(0.0,Speed * -1.0,0.0);
	
	if(self.is_on_floor()):
		Jumping = false
		SlopeHelper += (self.get_floor_angle() * slopepercentage)
	
	if(Input.is_key_pressed(KEY_D) && !Jumping):
		Direction += 1.0;
	
	if(Input.is_key_pressed(KEY_A) && !Jumping):
		Direction += -1.0;
	
	if(Input.is_key_pressed(KEY_SPACE)):
		if(self.is_on_floor()):
			JumpDirection = self.get_floor_normal()
			Jumping = true
			JumpAmount = JumpPower
			SavedDirection = Direction
	
	if(Jumping):
		Force[0] += SavedDirection * Speed 
		JumpAmount -= JumpPower * delta
		if(JumpAmount >= 0):
			Force += JumpDirection * JumpAmount
	else:
		Force[0] += Direction * Speed * SlopeHelper
		print(Force[0])
	
