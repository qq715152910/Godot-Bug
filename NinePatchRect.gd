extends NinePatchRect

#Original Image Size :640x479
const Original_SIZE = Vector2(640,479)


#This Is Nomal.
#When the Rect size is larger than the original image size:
const ZOOM_SIZE = Vector2(800,600)

#This Is Error.
#When the Rect size is smaller than the original image size:
#The border has been reduced and the pixels are completely distorted
const NARROW_SIZE = Vector2(363,455)

func _on_NormalTest_pressed():
	set_size(Original_SIZE)

func _on_ErrorTest_pressed():
	set_size(NARROW_SIZE)


func _on_ZoomTest_pressed():
	set_size(ZOOM_SIZE)
