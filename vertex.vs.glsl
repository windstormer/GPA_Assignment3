#version 410

layout(location = 0) in vec3 iv3vertex;
layout(location = 2) in vec2 iv3color;

uniform mat4 um4mvp;


out VS_OUT
{
vec2 tc;
} vs_out;

void main()
{
	gl_Position = um4mvp * vec4(iv3vertex, 1.0);
	vs_out.tc = iv3color;
}