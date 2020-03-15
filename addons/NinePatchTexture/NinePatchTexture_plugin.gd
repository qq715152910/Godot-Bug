tool
extends EditorPlugin

func _enter_tree():
	# When this plugin node enters tree, add the custom type
	add_custom_type("NinePatchTexture", "Control", preload("res://addons/NinePatchTexture/NinePatchTexture.gd"), preload("res://addons/NinePatchTexture/icon_nine_patch_rect.png"))


func _exit_tree():
	# When the plugin node exits the tree, remove the custom type
	remove_custom_type("NinePatchTexture")
