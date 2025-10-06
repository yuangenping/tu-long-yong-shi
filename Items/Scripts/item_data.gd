class_name ItemData extends Resource

@export var name : String = ""
@export_multiline var description : String = ""
@export var texturt : Texture2D
@export var test_name : String = ""

@export_category(" Item Use Effects ")
@export var effects : Array[ ItemEffect ]

func use() -> bool:
	if effects.is_empty() :
		return false
	
	for e in effects :
		if e : 
			e.use()
		
	return true
