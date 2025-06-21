extends StaticBody3D

func interact():
	var mat = $"..".get_surface_override_material(0)
	print(mat)
	mat.albedo_color = Color(0.5,0,0)
	$"..".set_surface_override_material(0, mat)
