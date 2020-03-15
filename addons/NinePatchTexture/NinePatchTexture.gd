tool

extends Control

export (Texture) var texture
export (bool) var draw_center = true
export (Rect2) var region_rect = Rect2(0,0,0,0)

export (int) var patch_margin_left = 0
export (int) var patch_margin_top = 0
export (int) var patch_margin_right = 0
export (int) var patch_margin_bottom = 0

export (Vector2) var offset = Vector2(0,0)
export (bool) var auto_limit_size = true

var image = Image.new()
var newtexture = ImageTexture.new()


func _ready():
	self.connect("resized",self,"_on_NinePatchTexture_resized")
	_update_texture()


func _draw():
	if newtexture:
		draw_texture(newtexture,Vector2(offset.x,offset.y))
	


func _process(delta):
	pass


func _update_texture():
	var src
	var src_size
	
	#limit_size
	if auto_limit_size:
		rect_min_size = Vector2(patch_margin_left + patch_margin_right + 1,patch_margin_top + patch_margin_bottom + 1)
	
	#rect_size
	var width = get_size().x
	var height = get_size().y
	
	#check_texture
	if texture:
		if region_rect.size.x > 0 or region_rect.size.y > 0 or region_rect.position.x > 0 or region_rect.position.y > 0:
			src = texture.get_data().get_rect(region_rect)
		else:
			src = texture.get_data()

	#check_src
	if src:
		src_size = src.get_size()
		#check_patch_rect
		if patch_margin_left < 0:
			patch_margin_left = 0

		if patch_margin_right < 0:
			patch_margin_right = 0

		if patch_margin_top < 0:
			patch_margin_top = 0

		if patch_margin_bottom < 0:
			patch_margin_bottom = 0
			
		if patch_margin_left > src_size.x:
			patch_margin_left = src_size.x

		if patch_margin_right > src_size.x:
			patch_margin_right = src_size.x

		if patch_margin_top > src_size.y:
			patch_margin_top = src_size.y

		if patch_margin_bottom > src_size.y:
			patch_margin_bottom = src_size.y
		
#		if patch_margin_left == src_size.x:
#			patch_margin_right = 0
#		else:
#			if patch_margin_left > 0 and patch_margin_right == 0:
#				patch_margin_right = 1
#
#		if patch_margin_top == src_size.x:
#			patch_margin_bottom = 0
#		else:
#			if patch_margin_top > 0 and patch_margin_bottom == 0:
#				patch_margin_bottom = 1
		
		if (patch_margin_left + patch_margin_right) > src_size.x:
			var remeber_left = src_size.x - patch_margin_right
			var remeber_right = src_size.x - patch_margin_left
			patch_margin_left = remeber_left
			patch_margin_right = remeber_right
		
		if (patch_margin_top + patch_margin_bottom) > src_size.y:
			var remeber_top = src_size.y - patch_margin_bottom
			var remeber_bottom = src_size.y - patch_margin_top
			patch_margin_top = remeber_top
			patch_margin_bottom = remeber_bottom
			
		#src.convert(Image.FORMAT_RGBA8)
		#create a new image.
		#image.create(width,height,true,Image.FORMAT_RGBA8)
		
		#scale
		if patch_margin_left == 0 or patch_margin_right == 0 or patch_margin_top == 0 or patch_margin_bottom == 0 or (width < patch_margin_left + patch_margin_right) or (height < patch_margin_top + patch_margin_right):
			src.resize(width,height)
			newtexture.create_from_image(src)
			newtexture.set_flags(4)
		else:
			#patch
			image.create(width,height,true,src.get_format())
			#left_top
			image.blit_rect(src,Rect2(0,0,patch_margin_left,patch_margin_top),Vector2(0,0))
			#right_top
			image.blit_rect(src,Rect2(src_size.x - patch_margin_right,0,patch_margin_right,patch_margin_top),Vector2(width - patch_margin_right,0))
			#left_bottom
			image.blit_rect(src,Rect2(0,src_size.y - patch_margin_bottom,patch_margin_left,patch_margin_bottom),Vector2(0,height - patch_margin_bottom))
			#right_bottom
			image.blit_rect(src,Rect2(src_size.x - patch_margin_right,src_size.y - patch_margin_bottom,patch_margin_right,patch_margin_bottom),Vector2(width - patch_margin_right,height - patch_margin_bottom))
			#top
			var top = src.get_rect(Rect2(patch_margin_left,0,src_size.x - (patch_margin_left + patch_margin_right),patch_margin_top))
			top.resize(width - (patch_margin_left + patch_margin_right),top.get_height())
			image.blit_rect(top,Rect2(0,0,top.get_width(),top.get_height()),Vector2(patch_margin_left,0))
			#bottom
			var bottom = src.get_rect(Rect2(patch_margin_left,src_size.y - patch_margin_bottom,src_size.x - (patch_margin_left + patch_margin_right),patch_margin_top))
			bottom.resize(width - (patch_margin_left + patch_margin_right),bottom.get_height())
			image.blit_rect(bottom,Rect2(0,0,bottom.get_width(),bottom.get_height()),Vector2(patch_margin_left,height - patch_margin_bottom))
			#left
			var left = src.get_rect(Rect2(0,patch_margin_top,patch_margin_left,src_size.y - (patch_margin_top + patch_margin_bottom)))
			left.resize(left.get_width(),height - (patch_margin_top + patch_margin_bottom))
			image.blit_rect(left,Rect2(0,0,left.get_width(),left.get_height()),Vector2(0,patch_margin_top))
			#right
			var right = src.get_rect(Rect2(src_size.x - patch_margin_right,patch_margin_top,patch_margin_right,src_size.y - (patch_margin_top + patch_margin_bottom)))
			right.resize(right.get_width(),height - (patch_margin_top + patch_margin_bottom))
			image.blit_rect(right,Rect2(0,0,right.get_width(),right.get_height()),Vector2(width - patch_margin_right,patch_margin_top))
			#center
			if draw_center:
				var center = src.get_rect(Rect2(patch_margin_left,patch_margin_top,src_size.x - (patch_margin_left + patch_margin_right),src_size.y - (patch_margin_top + patch_margin_bottom)))
				center.resize(width - (patch_margin_left + patch_margin_right),height - (patch_margin_top + patch_margin_bottom))
				image.blit_rect(center,Rect2(0,0,center.get_width(),center.get_height()),Vector2(patch_margin_left,patch_margin_top))
			
			newtexture.create_from_image(image)
			newtexture.set_flags(4)
	
	update()


func get_texture():
	return texture


#editor_update_draw
func _on_NinePatchTexture_resized():
	_update_texture()
