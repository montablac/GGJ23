extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Speed = 5.0;
var Force = Vector3(0.0,0.0,0.0);
var JumpDirection = Vector3(0.0,0.0,0.0)
var JumpAmount = 0
var Jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var Gravity = 5.0
	
	Force[1] = -Gravity
	Force = self.move_and_slide(Force,Vector3(0.0,1.0,0.0),true);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var Direction = 0;
	var JumpPower = 100;
	var NotMoving = true
	var Gravity = 5.0
	
	Force = Vector3(0.0,Speed * -1.0,0.0);
	
	if(self.is_on_floor()):
		Force[0] = 0.0
		Jumping = false
	
	if(Input.is_key_pressed(KEY_D)):
		Direction += 1.0;
	
	if(Input.is_key_pressed(KEY_A)):
		Direction += -1.0;
	
	if(Input.is_key_pressed(KEY_SPACE)):
		if(self.is_on_floor()):
			JumpDirection = self.get_floor_normal()
			Jumping = true
			JumpAmount = JumpPower
	
	
	Force[0] = Direction * Speed  
		
	
	if(Jumping):
		JumpAmount -= JumpPower * delta
		if(JumpAmount <= JumpPower):
			Force += JumpDirection * JumpAmount
	
