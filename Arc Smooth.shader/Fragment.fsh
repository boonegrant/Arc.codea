//
// Fragment shader: Arc
//

precision highp float;

// thickness of the arc
uniform float u_innerRadius; 
// edge smoothing
uniform float u_smooth;
// angle 1
uniform float u_a1;	
// angle 2
uniform float u_a2;	
// color
uniform vec4 u_color;


varying vec2 vTexCoord;

const float PI = 3.1415926535897932384626433832795;
const float PI_2 = 1.57079632679489661923;
const float PI_4 = 0.785398163397448309616;
const float TWOPI = 2.0*PI;
const float FOURPI = 4.0*PI;

void main() {
    float smoothing = u_smooth;
    vec4 col = vec4(0.0);
    float arc = 0.0;
    // convert to -1,1 space
    vec2 thisPoint = vTexCoord*2.0 - vec2(1.0); 
    float rDistance = length(thisPoint);
    float shell = smoothstep( u_innerRadius, u_innerRadius + smoothing, rDistance);
    shell *= smoothstep( 1.0 - smoothing, 1.0 + smoothing, 2.0 - rDistance); 
    // is thisPoint within circle and within thickness
    float thisAngle = mod(atan(thisPoint.x, thisPoint.y) + FOURPI - u_a1, TWOPI);
    arc = 1.0 - smoothstep( u_a2 - smoothing, u_a2 + smoothing, thisAngle);
    arc *= smoothstep( -smoothing, smoothing, thisAngle );
    //col = vec4( rDistance, (1.0-thisAngle/TWOPI), 1.0, shell*arc);
    col = vec4( u_color.r, u_color.g, u_color.b, shell*arc);
 
    gl_FragColor = col; 
}
