shader_type canvas_item;

//Public variable that can be accessed through a script from somwhere else
uniform float lerp_percent;

void fragment() {
	//Gets every pixel of the sprite and ignores empty space around it
	vec4 texture_color = texture(TEXTURE, UV);
	//Mixes the specified texture with a color (r,g,b,a) and sets it to specified value at the end
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	//Sets color of every pixel of the sprite to the final mixed color
	COLOR = final_color;
	
	//Can also access specific rgb channels on vectors
	//EX: vec2 example = final_color.rg (Grabs red and green channels from the final color vec4)
}
