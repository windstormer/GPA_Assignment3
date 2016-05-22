#version 410

layout(location = 0) in vec2 iv3vertex;
layout(location = 1) in vec2 iv2tex_coord;



out vec2 vv2tex_coord;


void main()
{

	gl_Position = vec4(iv3vertex,1.0, 1.0);
	vv2tex_coord = iv2tex_coord;
}