// MatCap Shader, (c) 2013 Jean Moreno

Shader "MatCap/Vertex/PlainBrightWireGrey"
{
	Properties
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
		_Brightness("Brightness", Float) = 7.0
	}
	
	Subshader
	{
		Tags { "RenderType"="Opaque" }
		
		Pass
		{
			Tags { "LightMode" = "Always" }
			
			Program "vp" {
// Vertex combos: 1
//   d3d9 - ALU: 8 to 8
SubProgram "opengl " {
Keywords { }
"!!GLSL
#ifdef VERTEX
varying vec4 xlv_COLOR;
varying vec2 xlv_TEXCOORD0;
attribute vec4 TANGENT;


void main ()
{
  vec2 capCoord_1;
  vec4 v_2;
  v_2.x = gl_ModelViewMatrixInverseTranspose[0].x;
  v_2.y = gl_ModelViewMatrixInverseTranspose[1].x;
  v_2.z = gl_ModelViewMatrixInverseTranspose[2].x;
  v_2.w = gl_ModelViewMatrixInverseTranspose[3].x;
  capCoord_1.x = dot (v_2.xyz, gl_Normal);
  vec4 v_3;
  v_3.x = gl_ModelViewMatrixInverseTranspose[0].y;
  v_3.y = gl_ModelViewMatrixInverseTranspose[1].y;
  v_3.z = gl_ModelViewMatrixInverseTranspose[2].y;
  v_3.w = gl_ModelViewMatrixInverseTranspose[3].y;
  capCoord_1.y = dot (v_3.xyz, gl_Normal);
  gl_Position = (gl_ModelViewProjectionMatrix * gl_Vertex);
  xlv_TEXCOORD0 = ((capCoord_1 * 0.5) + 0.5);
  xlv_COLOR = TANGENT;
}


#endif
#ifdef FRAGMENT
varying vec4 xlv_COLOR;
varying vec2 xlv_TEXCOORD0;
uniform float _Brightness;
uniform sampler2D _MatCap;
uniform vec4 _Color;
void main ()
{
  vec3 tmpvar_1;
  vec3 t_2;
  t_2 = max (min ((xlv_COLOR.xyz / ((abs(dFdx(xlv_COLOR.xyz)) + abs(dFdy(xlv_COLOR.xyz))) * 0.5)), 1.0), 0.0);
  tmpvar_1 = (t_2 * (t_2 * (3.0 - (2.0 * t_2))));
  vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix (vec3(0.5, 0.5, 0.5), vec3(0.0, 0.0, 0.0), vec3(min (min (tmpvar_1.x, tmpvar_1.y), tmpvar_1.z)));
  gl_FragData[0] = (((_Color * texture2D (_MatCap, xlv_TEXCOORD0)) * _Brightness) + tmpvar_3);
}


#endif
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
"vs_3_0
; 8 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_color0 o2
def c8, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_tangent0 v2
dp3 r0.x, v1, c4
dp3 r0.y, v1, c5
mov o2, v2
mad o1.xy, r0, c8.x, c8.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define tangent vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
vec2 xll_matrixindex_mf2x2_i (mat2 m, int i) { vec2 v; v.x=m[0][i]; v.y=m[1][i]; return v; }
vec3 xll_matrixindex_mf3x3_i (mat3 m, int i) { vec3 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; return v; }
vec4 xll_matrixindex_mf4x4_i (mat4 m, int i) { vec4 v; v.x=m[0][i]; v.y=m[1][i]; v.z=m[2][i]; v.w=m[3][i]; return v; }
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 322
struct v2f {
    highp vec4 pos;
    highp vec2 cap;
    highp vec4 barycentric;
};
#line 315
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 tangent;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 329
uniform highp vec4 _Color;
#line 341
uniform sampler2D _MatCap;
uniform highp float _Brightness;
#line 349
#line 329
v2f vert( in appdata v ) {
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    #line 333
    mediump vec2 capCoord;
    capCoord.x = dot( xll_matrixindex_mf4x4_i (glstate_matrix_invtrans_modelview0, 0).xyz, v.normal);
    capCoord.y = dot( xll_matrixindex_mf4x4_i (glstate_matrix_invtrans_modelview0, 1).xyz, v.normal);
    o.cap = ((capCoord * 0.5) + 0.5);
    #l
    return o;
}
in vec4 TANGENT;
out highp vec2 xlv_TEXCOORD0;
out highp vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.tangent = vec4(TANGENT);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.cap);
    xlv_COLOR = vec4(xl_retval.barycentric);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
float xll_fwidth_f(float f) {
  return fwidth(f);
}
vec2 xll_fwidth_vf2(vec2 v) {
  return fwidth(v);
}
vec3 xll_fwidth_vf3(vec3 v) {
  return fwidth(v);
}
vec4 xll_fwidth_vf4(vec4 v) {
  return fwidth(v);
}
mat2 xll_fwidth_mf2x2(mat2 m) {
  return mat2( fwidth(m[0]), fwidth(m[1]));
}
mat3 xll_fwidth_mf3x3(mat3 m) {
  return mat3( fwidth(m[0]), fwidth(m[1]), fwidth(m[2]));
}
mat4 xll_fwidth_mf4x4(mat4 m) {
  return mat4( fwidth(m[0]), fwidth(m[1]), fwidth(m[2]), fwidth(m[3]));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 322
struct v2f {
    highp vec4 pos;
    highp vec2 cap;
    highp vec4 barycentric;
};
#line 315
struct appdata {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec4 tangent;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 329
uniform highp vec4 _Color;
#line 341
uniform sampler2D _MatCap;
uniform highp float _Brightness;
#line 349
#line 343
highp float edgeFactor( in highp vec3 vBC ) {
    #line 345
    highp vec3 d = xll_fwidth_vf3(vBC);
    highp vec3 a3 = smoothstep( vec3( 0.0), (d * 0.5), vBC);
    return min( min( a3.x, a3.y), a3.z);
}
#line 349
highp vec4 frag( in v2f i ) {
    highp vec4 mc = texture( _MatCap, i.cap);
    highp vec3 wireColor = mix( vec3( 0.5, 0.5, 0.5), vec3( 0.0, 0.0, 0.0), vec3( edgeFactor( i.barycentric.xyz)));
    #line 353
    return (((_Color * mc) * _Brightness) + vec4( wireColor, 1.0));
}
in highp vec2 xlv_TEXCOORD0;
in highp vec4 xlv_COLOR;
void main() {
    highp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.cap = vec2(xlv_TEXCOORD0);
    xlt_i.barycentric = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   d3d9 - ALU: 21 to 21, TEX: 1 to 1
SubProgram "opengl " {
Keywords { }
"!!GLSL"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
Float 1 [_Brightness]
SetTexture 0 [_MatCap] 2D
"ps_3_0
; 21 ALU, 1 TEX
dcl_2d s0
def c2, 0.50000000, 2.00000000, 3.00000000, -0.50000000
def c3, 1.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_color0 v1.xyz
dsy r1.xyz, v1
dsx r0.xyz, v1
abs r1.xyz, r1
abs r0.xyz, r0
add r0.xyz, r0, r1
mul r0.xyz, r0, c2.x
rcp r0.x, r0.x
rcp r0.z, r0.z
rcp r0.y, r0.y
mul_sat r0.xyz, v1, r0
mad r1.xyz, -r0, c2.y, c2.z
mul r0.xyz, r0, r0
mul r0.xyz, r0, r1
min r0.x, r0, r0.y
min r0.x, r0, r0.z
mad r1.xyz, r0.x, c2.w, -c2.w
texld r0, v0, s0
mov r1.w, c3.x
mul r0, r0, c0
mad oC0, r0, c1.x, r1
"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 75

		}
	}
}