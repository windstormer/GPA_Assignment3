#version 410

in VS_OUT
{
vec2 tc;
} fs_in;

uniform sampler2D tex;
out vec4 color;

void main()
{
    color = texture(tex,fs_in.tc);
}