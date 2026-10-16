shader_type spatial;
//render_mode unshaded;
render_mode depth_draw_always;

group_uniforms colors;
uniform vec4 smoke_color : source_color = vec4(0.7, 0.7, 0.7, 0.7);
uniform vec4 highlight_color : source_color;
uniform vec4 shadow_color : source_color;
group_uniforms;

group_uniforms Shape;
uniform float displacementStrength = 0.1;
uniform float displacementSpeed = 0.1;
uniform float noiseDensity = 8.0;
group_uniforms;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

varying vec3 normalWS;
varying vec2 screenUV;

vec2 voronoi_noise_randomVector (vec2 uv, float offset)
{
    mat2 m;
	m[0][0] = 15.27;
	m[0][1] = 47.63;
	m[1][0] = 99.41;
	m[1][1] = 89.98;
    uv = fract(sin(m * uv) * 46839.32);
    return vec2(sin(uv.y*+offset)*0.5+0.5, cos(uv.x*offset)*0.5+0.5);
}

float Voronoi(vec2 uv, float AngleOffset, float CellDensity)
{
	float Out = 0.0;
	float Cells = 0.0;
    vec2 g = floor(uv * CellDensity);
    vec2 f = fract(uv * CellDensity);
    float t = 8.0;
    vec3 res = vec3(8.0, 0.0, 0.0);

    for(int y=-1; y<=1; y++)
    {
        for(int x=-1; x<=1; x++)
        {
            vec2 lattice = vec2(float(x),float(y));
            vec2 offset = voronoi_noise_randomVector(lattice + g, AngleOffset);
            float d = distance(lattice + offset, f);
            if(d < res.x)
            {
                res = vec3(d, offset.x, offset.y);
                Out = res.x;
                Cells = res.y;
            }
        }
    }
	return Out;
}

vec3 RotateAboutAxis(vec3 In, vec3 Axis, float Rotation)
{
    Rotation = radians(Rotation);
    float s = sin(Rotation);
    float c = cos(Rotation);
    float one_minus_c = 1.0 - c;

    Axis = normalize(Axis);
   	mat3 rot_mat;
	rot_mat[0][0] = one_minus_c * Axis.x * Axis.x + c;
	rot_mat[0][1] = one_minus_c * Axis.x * Axis.y - Axis.z * s;
	rot_mat[0][2] = one_minus_c * Axis.z * Axis.x + Axis.y * s;
	rot_mat[1][0] = one_minus_c * Axis.x * Axis.y + Axis.z * s;
	rot_mat[1][1] = one_minus_c * Axis.y * Axis.y + c;
	rot_mat[1][2] = one_minus_c * Axis.y * Axis.z - Axis.x * s;
	rot_mat[2][0] = one_minus_c * Axis.z * Axis.x - Axis.y * s;
	rot_mat[2][1] = one_minus_c * Axis.y * Axis.z + Axis.x * s;
	rot_mat[2][2] = one_minus_c * Axis.z * Axis.z + c;
	return rot_mat *  In;
}

float RandomRange(vec2 Seed, float Min, float Max)
{
    float randomno =  fract(sin(dot(Seed, vec2(12.9898, 78.233)))*43758.5453);
    return mix(Min, Max, randomno);
}

float VoronoiOffset(vec3 uv, float rn){
	//float randomno = RandomRange(vec2(TIME), 0., 100.) * 0.0001;
	vec3 rotateduv = RotateAboutAxis(uv, vec3(0., 1., 0.), 90.);
	float noiseOffset = pow(Voronoi(uv.xy + (TIME * displacementSpeed + rn), 2.0, noiseDensity), 0.9);
	float rotatedNoiseOffset = pow(Voronoi(rotateduv.xy + (TIME * displacementSpeed + rn), 2.0, noiseDensity), 0.9);
	noiseOffset = noiseOffset + rotatedNoiseOffset;
	return clamp((noiseOffset), 0.0, 1.0) * displacementStrength;
}

// We need this to pass the alpha value to the light pass.
void vertex() {
	vec2 uv = UV;
	vec3 position = VERTEX;
	vec3 normal = NORMAL;

	float noiseOffset = VoronoiOffset(position, INSTANCE_CUSTOM.x);
	vec3 newPosition = position + normal * noiseOffset;

	vec3 posPlusTangent = position + TANGENT * 0.01;
    noiseOffset = VoronoiOffset(posPlusTangent, INSTANCE_CUSTOM.x);
    posPlusTangent = posPlusTangent + normal * noiseOffset;

    vec3 posPlusBitangent = position + BINORMAL * 0.01;
    noiseOffset = VoronoiOffset(posPlusBitangent, INSTANCE_CUSTOM.x);
    posPlusBitangent = posPlusBitangent + normal * noiseOffset;

    vec3 modifiedTangent = posPlusTangent - newPosition;
    vec3 modifiedBitangent = posPlusBitangent - newPosition;
    vec3 modifiedNormal = cross(modifiedTangent, modifiedBitangent);
    vec3 newNormal = normalize(modifiedNormal);

	VERTEX = newPosition;
	NORMAL = newNormal;

	normalWS = mat3(MODEL_MATRIX) * newNormal;
}

float hash(vec2 p){
	vec3 p3  = fract(vec3(p.xyx) * .1031);
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.x + p3.y) * p3.z);
}

float luminance(vec3 color) {
	const vec3 magic = vec3(0.2125, 0.7154, 0.0721);
	return dot(magic, color);
}

void fragment() {
	screenUV = SCREEN_UV;
	vec3 col = vec3(0.7);
	vec3 screenCol = texture(SCREEN_TEXTURE, screenUV).rgb;
	ALBEDO = mix(screenCol, smoke_color.rgb, smoke_color.a );
}

void light() {
	vec3 lightDir = mat3(INV_VIEW_MATRIX) * LIGHT;
	float light = clamp(dot(normalize(normalWS), normalize(lightDir)), 0.0, 1.0);
	light = floor(light*2.0)/2.0; // posterize
	vec3 col = mix(shadow_color, highlight_color, light).rgb;

	DIFFUSE_LIGHT = col;

}