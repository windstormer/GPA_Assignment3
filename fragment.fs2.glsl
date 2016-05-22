#version 410


layout(location = 0) out vec4 fragColor;


in vec2 vv2tex_coord;

uniform sampler2D tex;
uniform int select;
uniform int select1;
uniform int select2;
uniform vec2 img_size;
uniform float offset;
uniform float barx;
uniform int bcom;

vec4 color;

int kernel[9]= int[9](0,-1,0,-1,5,-1,0,-1,0);

void choose(int s)
{
 if(s==0)
        {

            fragColor = texture(tex,vv2tex_coord);

        }
        if(s==1)
        {

            vec4 Left_Color = texture(tex,vv2tex_coord-0.005);
            vec4 Right_Color = texture(tex,vv2tex_coord+0.005);
            float Color_R= Left_Color.r*0.299+Left_Color.g*0.587+Left_Color.b*0.114;
            float Color_G= Right_Color.g;
            float Color_B= Right_Color.b;
            fragColor = vec4(Color_R,Color_G,Color_B,1.0);

        }

        if(s==2)
        {

            int n =0;
            int half_size = 2;
            int i=0,j=0;
            int nbins = 8;

            color = vec4(0);
            //blur

            for (  i = (-1)*half_size; i <= half_size ; ++i )
            {
                for (  j = (-1)*half_size; j <= half_size ; ++j )
                {
                    vec4 c= texture(tex,vv2tex_coord + vec2(i,j)/img_size);
                    color+= c;
                    n++;
                }
            }
            color /=n;

            //Quantization
            vec4 tex_color = color;
            float r= floor(tex_color.r * float(nbins)) / float(nbins);
            float g= floor(tex_color.g * float(nbins)) / float(nbins);
            float b = floor(tex_color.b * float(nbins)) / float(nbins);
            vec4 blur_quantization = vec4(r,g,b,tex_color.a);

            //DoG

            float sigma_e = 2.0f;
            float sigma_r = 2.8f;
            float phi = 3.4f;
            float tau = 0.99f;
            float twoSigmaESquared = 2.0 * sigma_e * sigma_e;
            float twoSigmaRSquared = 2.0 * sigma_r * sigma_r;
            int halfWidth = int(ceil( 2.0 * sigma_r ));

            vec2 sum = vec2(0.0);
            vec2 norm = vec2(0.0);
            for (  i= -halfWidth; i<= halfWidth; ++i)
            {
                for ( j = -halfWidth; j <= halfWidth; ++j )
                {
                    float d = length(vec2(i,j));
                    vec2 kernel= vec2( exp( -d * d / twoSigmaESquared),
                                       exp( -d * d / twoSigmaRSquared));
                    vec4 c= texture(tex,vv2tex_coord+vec2(i,j)/img_size);
                    vec2 L= vec2(0.299 * c.r+ 0.587 * c.g+ 0.114 * c.b);
                    norm += 2.0 * kernel;
                    sum += kernel * L;
                }
            }
            sum /= norm;
            float H = 100.0 * (sum.x-tau * sum.y);
            fragColor = (H > 0.0)?blur_quantization: vec4(0.0,0.0,0.0,0.0);


        }

        if(s==3)
        {


            vec4 c= texture(tex,vv2tex_coord + vec2(2,2)/img_size);
            float grayscale = 0.2126*c.r+0.7152*c.g+0.0722*c.b;
            fragColor = 8 * vec4(grayscale,grayscale,grayscale,1.0);

            for (int i = 0; i < 3; i++)
            {
                for(int j=0; j<3; j++)
                {
                    if(!(i==1&&j==1))
                    {
                        c= texture(tex,vv2tex_coord + vec2(i,j)/img_size);
                        grayscale = 0.2126*c.r+0.7152*c.g+0.0722*c.b;
                        fragColor -= vec4(grayscale,grayscale,grayscale,1.0);
                    }
                }
            }


        }

        if(s==4)
        {

            vec2 temp = vv2tex_coord;
            temp.x += sin(vv2tex_coord.y * 4 * 2 *3.1415926+offset)/100;
            fragColor = texture(tex,temp);


        }

        if(s==5)
        {

            int n =0;
            int half_size = 2;
            int i=0,j=0;
            int nbins = 8;

            color = vec4(0);
            //blur

            for (  i = (-1)*half_size; i <= half_size ; ++i )
            {
                for (  j = (-1)*half_size; j <= half_size ; ++j )
                {
                    vec4 c= texture(tex,vv2tex_coord + vec2(i,j)/img_size);
                    color+= c;
                    n++;
                }
            }
            color /=n;

            half_size = 4;
            vec4 seccolor = vec4(0);
            for (  i = (-1)*half_size; i <= half_size ; ++i )
            {
                for (  j = (-1)*half_size; j <= half_size ; ++j )
                {
                    vec4 c= texture(tex,vv2tex_coord + vec2(i,j)/img_size);
                    seccolor+= c;
                    n++;
                }
            }
            seccolor /=n;

            fragColor = color+seccolor;

        }

        if(s==6)
        {

            vec4 sum = vec4(0);
            for (int i = 0; i < 3; i++)
            {
                for(int j=0; j<3; j++)
                {
                    vec4 c= texture(tex,vv2tex_coord + vec2(i,j)/img_size);
                    sum+=c*kernel[i*3+j];
                }
            }
            fragColor = sum;

        }

        if(s==7)
        {

            vec4 sum = vec4(0);
            for (int i = 0; i < 3; i++)
            {
                for(int j=0; j<3; j++)
                {
                    vec4 c= texture(tex,vv2tex_coord + vec2(i,j)/img_size);
                    sum = max(sum,c);
                }
            }
            fragColor = sum;

        }
}


void main()
{
if(bcom==0)
choose(select);
else
{
    if(vv2tex_coord.x>barx+0.001)
    {
        choose(select2);
    }
	else
    {
        if(vv2tex_coord.x>barx-0.001 && vv2tex_coord.x<barx+0.001)
            fragColor = vec4(1.0,0.0,0.0,1.0);
        else
            choose(select1);
    }
	}
}
