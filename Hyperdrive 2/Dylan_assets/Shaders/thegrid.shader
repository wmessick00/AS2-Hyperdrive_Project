// Compiled shader for all platforms, uncompressed size: 41.9KB

Shader "Skyscreen/TheGrid" {
Properties {
 iPrimaryColor ("PrimaryColor", Color) = (1,1,1,1)
 iFloorHeight ("FloorHeight", Float) = -11
 iIntensity ("Intensity", Float) = 0.5
 iIntensityTime ("IntensityTime", Float) = 0.5
}
SubShader { 


 // Stats for Vertex shader:
 //       d3d11 : 8 math
 //        d3d9 : 10 math
 //      opengl : 10 math
 // Stats for Fragment shader:
 //       d3d11 : 97 math, 4 branch
 //        d3d9 : 274 math, 11 branch
 //      opengl : 932 math
 Pass {
  Fog { Mode Off }
Program "vp" {
SubProgram "opengl " {
// Stats: 10 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
"3.0-!!ARBvp1.0
PARAM c[9] = { { 0 },
		state.matrix.mvp,
		program.local[5..8] };
MOV result.texcoord[0].xy, vertex.texcoord[0];
MOV result.texcoord[0].zw, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[1].w, vertex.position, c[8];
DP4 result.texcoord[1].z, vertex.position, c[7];
DP4 result.texcoord[1].y, vertex.position, c[6];
DP4 result.texcoord[1].x, vertex.position, c[5];
END
# 10 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
// Stats: 10 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
"vs_3_0
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
def c8, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov o1.xy, v1
mov o1.zw, c8.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
dp4 o2.w, v0, c7
dp4 o2.z, v0, c6
dp4 o2.y, v0, c5
dp4 o2.x, v0, c4
"
}
SubProgram "d3d11 " {
// Stats: 8 math
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
ConstBuffer "UnityPerDraw" 336
Matrix 0 [glstate_matrix_mvp]
Matrix 192 [_Object2World]
BindCB  "UnityPerDraw" 0
"vs_4_0
eefiecednkbfgbdpdfiboilkoebgffjoaicfdlmeabaaaaaamaacaaaaadaaaaaa
cmaaaaaaiaaaaaaapaaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaaebaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapadaaaafaepfdejfeejepeoaafeeffiedepepfceeaaklkl
epfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaklklklfdeieefcmiabaaaaeaaaabaahcaaaaaa
fjaaaaaeegiocaaaaaaaaaaabaaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaad
dcbabaaaabaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagfaaaaadpccabaaaacaaaaaagiaaaaacabaaaaaadiaaaaaipcaabaaa
aaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaadcaaaaakpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaakgbkbaaaaaaaaaaa
egaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaa
pgbpbaaaaaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaa
abaaaaaadgaaaaaimccabaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaaaaaaaaa
anaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaaamaaaaaaagbabaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaaaaaaaaa
aoaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaacaaaaaa
egiocaaaaaaaaaaaapaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadoaaaaab
"
}
SubProgram "gles3 " {
"!!GLES3#version 300 es


#ifdef VERTEX

in vec4 _glesVertex;
in vec4 _glesMultiTexCoord0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 _Object2World;
out highp vec4 xlv_TEXCOORD0;
out highp vec4 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.zw = vec2(0.0, 0.0);
  tmpvar_1.xy = _glesMultiTexCoord0.xy;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = (_Object2World * _glesVertex);
}



#endif
#ifdef FRAGMENT

out mediump vec4 _glesFragData[4];
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 iPrimaryColor;
uniform highp float iFloorHeight;
uniform highp float iIntensity;
uniform highp float iIntensityTime;
in highp vec4 xlv_TEXCOORD1;
void main ()
{
  int i_1;
  highp float inten_2;
  highp vec3 rd_3;
  highp vec3 ro_4;
  ro_4 = _WorldSpaceCameraPos;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize((xlv_TEXCOORD1.xyz - _WorldSpaceCameraPos));
  rd_3 = tmpvar_5;
  inten_2 = pow ((1.0 - abs(tmpvar_5.y)), (11.0 + ((1.0 - iIntensity) * 30.0)));
  highp float r_6;
  if ((abs(tmpvar_5.z) > (1e-08 * abs(tmpvar_5.x)))) {
    highp float y_over_x_7;
    y_over_x_7 = (tmpvar_5.x / tmpvar_5.z);
    highp float s_8;
    highp float x_9;
    x_9 = (y_over_x_7 * inversesqrt(((y_over_x_7 * y_over_x_7) + 1.0)));
    s_8 = (sign(x_9) * (1.5708 - (sqrt((1.0 - abs(x_9))) * (1.5708 + (abs(x_9) * (-0.214602 + (abs(x_9) * (0.0865667 + (abs(x_9) * -0.0310296)))))))));
    r_6 = s_8;
    if ((tmpvar_5.z < 0.0)) {
      if ((tmpvar_5.x >= 0.0)) {
        r_6 = (s_8 + 3.14159);
      } else {
        r_6 = (r_6 - 3.14159);
      };
    };
  } else {
    r_6 = (sign(tmpvar_5.x) * 1.5708);
  };
  highp float tmpvar_10;
  tmpvar_10 = (iIntensityTime * 1.7);
  inten_2 = ((inten_2 + ((pow ((((fract((sin((floor(((r_6 * 4.0) + tmpvar_10)) * 11.11)) * 547.89)) * (-0.2 + (iIntensity * 0.7))) + (fract((sin((floor(((r_6 * 8.0) - tmpvar_10)) * 11.11)) * 547.89)) * 0.25)) + (fract((sin((floor(((r_6 * 16.0) + tmpvar_10)) * 11.11)) * 547.89)) * 0.125)), 5.0) * (1.0/(((tmpvar_5.y * tmpvar_5.y) * (1.0 - iIntensity))))) * 0.1)) * 3.0);
  i_1 = 0;
  for (int i_1 = 0; i_1 < 6; ) {
    highp float tmpvar_11;
    tmpvar_11 = float(i_1);
    highp vec3 tmpvar_12;
    tmpvar_12.xz = vec2(0.0, 0.0);
    tmpvar_12.y = ((iFloorHeight + -5000.0) + (tmpvar_11 * -15000.0));
    highp vec3 tmpvar_13;
    highp vec3 tmpvar_14;
    tmpvar_14 = (ro_4 - tmpvar_12);
    highp vec3 tmpvar_15;
    tmpvar_15.x = dot (vec3(0.0, -1.0, 0.0), tmpvar_14);
    tmpvar_15.y = dot (((tmpvar_14.yzx * vec3(0.0, 1.0, 0.0)) - (tmpvar_14.zxy * vec3(0.0, 0.0, 1.0))), rd_3);
    tmpvar_15.z = dot (((vec3(0.0, 1.0, 0.0) * tmpvar_14.zxy) - (vec3(1.0, 0.0, 0.0) * tmpvar_14.yzx)), rd_3);
    tmpvar_13 = (tmpvar_15 / rd_3.y);
    if ((tmpvar_13.x > 0.0)) {
      int j_16;
      highp float md2_17;
      highp float md_18;
      highp vec2 mg_19;
      highp vec2 n_20;
      highp vec2 tmpvar_21;
      tmpvar_21 = floor(((tmpvar_13.yz * (0.0001 + (0.0003 * tmpvar_11))) + (((180.0 + iIntensityTime) * (tmpvar_11 - 3.0)) * 4.4)));
      n_20 = tmpvar_21;
      md_18 = 8.0;
      md2_17 = 8.0;
      j_16 = 0;
      while (true) {
        int i_22;
        if ((j_16 > 1)) {
          break;
        };
        i_22 = -1;
        while (true) {
          if ((i_22 > 1)) {
            break;
          };
          highp vec2 tmpvar_23;
          tmpvar_23.x = float(i_22);
          tmpvar_23.y = float(j_16);
          highp vec2 p_24;
          p_24 = (n_20 + tmpvar_23);
          highp vec2 tmpvar_25;
          tmpvar_25.x = sin(((p_24.x * 500.0) + (p_24.y * 100.0)));
          tmpvar_25.y = cos(((p_24.x * 250.0) + (p_24.y * 48.0)));
          highp vec2 tmpvar_26;
          tmpvar_26 = fract(tmpvar_25);
          highp float tmpvar_27;
          tmpvar_27 = max (abs(tmpvar_26.x), abs(tmpvar_26.y));
          if ((tmpvar_27 < md_18)) {
            md2_17 = md_18;
            md_18 = tmpvar_27;
            mg_19 = tmpvar_23;
          } else {
            if ((tmpvar_27 < md2_17)) {
              md2_17 = tmpvar_27;
            };
          };
          i_22 = (i_22 + 1);
        };
        j_16 = (j_16 + 1);
      };
      highp vec3 tmpvar_28;
      tmpvar_28.xy = (tmpvar_21 + mg_19);
      tmpvar_28.z = (md2_17 - md_18);
      inten_2 = (inten_2 + (exp((-100.0 * (tmpvar_28.z - 0.02))) * 0.1));
    };
    i_1 = (i_1 + 1);
  };
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (iPrimaryColor.xyz * inten_2);
  _glesFragData[0] = tmpvar_29;
  gl_FragDepth = 0.9999;
}



#endif"
}
}
Program "fp" {
SubProgram "opengl " {
// Stats: 932 math
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [iPrimaryColor]
Float 2 [iFloorHeight]
Float 3 [iIntensity]
Float 4 [iIntensityTime]
"3.0-!!ARBfp1.0
PARAM c[19] = { program.local[0..4],
		{ 0, -80000, -65000, -50000 },
		{ -35000, 0, -20000, -13.200001 },
		{ -8.8000002, 0, 8.8000002, 1 },
		{ 0.99989998, 0, -1, -5000 },
		{ 11, 30, 3.141593, 1.570796 },
		{ -0.01348047, 0.05747731, 0.1212391, 0.1956359 },
		{ 0.33299461, 0.99999559, 4, 1.7 },
		{ 11.11, 547.89001, -0.2, 0.69999999 },
		{ 8, 0.25, 16, 0.125 },
		{ 5, 0.1, 3, 2.718282 },
		{ -100, 9.9999997e-005, 180, 500 },
		{ 100, 250, 48, 0.02 },
		{ -1, 1, 0.00040000002, 0.00070000003 },
		{ 4.4000001, 0.001, 0.0013, 0.0016 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R5.xy, c[6].xzzw;
MOV R1.w, c[15].z;
ADD R2.w, R1, c[4].x;
ADD R0.y, R5, c[2].x;
MOV R0.xz, c[5].x;
ADD R1.xyz, -R0, c[0];
MUL R2.xyz, -R1.yzxw, c[7].wyyw;
MUL R3.xyz, -R1.zxyw, c[7].yyww;
ADD R0.xyz, fragment.texcoord[1], -c[0];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
MAD R3.xyz, R1.yzxw, c[7].ywyw, R3;
DP3 R3.y, R0, R3;
MAD R2.xyz, R1.zxyw, c[7].ywyw, R2;
DP3 R3.x, R1, c[8].yzyw;
RCP R0.w, R0.y;
DP3 R3.z, R0, R2;
MUL R2.xyz, R0.w, R3;
MUL R1.x, R2.w, c[7];
MAD R1.xy, R2.yzzw, c[17].z, R1.x;
FLR R1.xy, R1;
ADD R3.xy, R1, c[8].zyzw;
MUL R1.z, R3.y, c[16];
MUL R1.w, R3.y, c[16].x;
MAD R1.z, R3.x, c[16].y, R1;
MAD R1.w, R3.x, c[15], R1;
COS R3.y, R1.z;
SIN R3.x, R1.w;
FRC R3.xy, R3;
ABS R1.z, R3.y;
ABS R1.w, R3.x;
MAX R2.z, R1.w, R1;
SLT R3.w, R2.z, c[13].x;
SLT R1.z, c[5].x, R2.x;
MUL R1.w, R1.z, R3;
CMP R2.y, -R1.w, R2.z, c[13].x;
MUL R3.y, R1, c[16].x;
MOV R1.w, c[7];
ABS R3.x, R3.w;
CMP R3.z, -R3.x, c[5].x, R1.w;
MUL R3.x, R1.y, c[16].z;
MAD R4.x, R1, c[15].w, R3.y;
MAD R3.x, R1, c[16].y, R3;
COS R3.y, R3.x;
SIN R3.x, R4.x;
FRC R3.xy, R3;
MUL R4.x, R1.z, R3.z;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R3.z, R3.x, R3.y;
SLT R4.y, R3.z, R2;
MUL R3.x, R3.w, R4;
CMP R3.x, -R3, R2.z, c[13];
MUL R2.z, R1, R4.y;
CMP R3.w, -R2.z, R2.y, R3.x;
ABS R3.y, R4;
CMP R3.x, -R3.y, c[5], R1.w;
MUL R4.y, R1.z, R3.x;
ADD R3.xy, R1, c[7].wyzw;
SLT R4.x, R3.z, R3.w;
MUL R4.x, R4.y, R4;
CMP R2.y, -R2.z, R3.z, R2;
MUL R4.y, R3, c[16].z;
MUL R4.z, R3.y, c[16].x;
MAD R3.y, R3.x, c[16], R4;
MAD R3.x, R3, c[15].w, R4.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R2.z, R3.y;
ABS R3.x, R3;
MAX R2.z, R3.x, R2;
SLT R4.y, R2.z, R2;
CMP R3.x, -R4, R3.z, R3.w;
MUL R3.z, R1, R4.y;
CMP R3.w, -R3.z, R2.y, R3.x;
ABS R3.y, R4;
CMP R3.x, -R3.y, c[5], R1.w;
MUL R4.y, R1.z, R3.x;
ADD R3.xy, R1, c[17];
SLT R4.x, R2.z, R3.w;
MUL R4.x, R4.y, R4;
CMP R2.y, -R3.z, R2.z, R2;
CMP R2.z, -R4.x, R2, R3.w;
MUL R4.y, R3, c[16].z;
MUL R4.z, R3.y, c[16].x;
MAD R3.y, R3.x, c[16], R4;
MAD R3.x, R3, c[15].w, R4.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R3.z, R3.x, R3.y;
SLT R3.y, R3.z, R2;
MUL R3.w, R1.z, R3.y;
CMP R2.z, -R3.w, R2.y, R2;
ABS R3.x, R3.y;
CMP R3.x, -R3, c[5], R1.w;
MUL R4.y, R1.z, R3.x;
ADD R3.xy, R1, c[7].ywzw;
SLT R4.x, R3.z, R2.z;
MUL R4.x, R4.y, R4;
ADD R1.xy, R1, c[7].w;
CMP R2.y, -R3.w, R3.z, R2;
MUL R4.y, R3, c[16].z;
MUL R4.z, R3.y, c[16].x;
MAD R3.y, R3.x, c[16], R4;
MAD R3.x, R3, c[15].w, R4.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R3.x, R3, R3.y;
CMP R3.y, -R4.x, R3.z, R2.z;
SLT R3.w, R3.x, R2.y;
MUL R2.z, R1, R3.w;
CMP R3.y, -R2.z, R2, R3;
ABS R3.z, R3.w;
CMP R3.w, -R3.z, c[5].x, R1;
CMP R2.y, -R2.z, R3.x, R2;
SLT R3.z, R3.x, R3.y;
MUL R3.w, R1.z, R3;
MUL R3.z, R3.w, R3;
MUL R3.w, R1.y, c[16].z;
MUL R4.x, R1.y, c[16];
MAD R1.y, R1.x, c[16], R3.w;
MAD R1.x, R1, c[15].w, R4;
COS R1.y, R1.y;
SIN R1.x, R1.x;
FRC R1.xy, R1;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R2.z, R1.x, R1.y;
SLT R3.w, R2.z, R2.y;
ABS R1.y, R3.w;
CMP R1.y, -R1, c[5].x, R1.w;
CMP R1.x, -R3.z, R3, R3.y;
MUL R3.w, R1.z, R3;
CMP R3.x, -R3.w, R2.y, R1;
SLT R1.x, R2.z, R3;
MUL R1.y, R1.z, R1;
MUL R3.y, R1, R1.x;
MOV R1.y, c[8].w;
CMP R4.w, -R3.y, R2.z, R3.x;
MOV R1.xz, c[5].x;
ADD R1.y, R1, c[2].x;
ADD R1.xyz, -R1, c[0];
MUL R3.xyz, -R1.zxyw, c[7].yyww;
MAD R3.xyz, R1.yzxw, c[7].ywyw, R3;
DP3 R3.y, R0, R3;
MUL R4.xyz, -R1.yzxw, c[7].wyyw;
MAD R4.xyz, R1.zxyw, c[7].ywyw, R4;
DP3 R3.z, R0, R4;
DP3 R3.x, R1, c[8].yzyw;
MUL R1.xyz, R0.w, R3;
MUL R4.x, R2.w, c[6].w;
MAD R3.xy, R1.yzzw, c[15].y, R4.x;
CMP R1.y, -R3.w, R2.z, R2;
FLR R3.xy, R3;
ADD R3.zw, R3.xyxy, c[8].xyzy;
ADD R1.y, R4.w, -R1;
MUL R1.z, R3.w, c[16];
MUL R2.y, R3.w, c[16].x;
MAD R1.z, R3, c[16].y, R1;
MAD R2.y, R3.z, c[15].w, R2;
ADD R1.y, R1, -c[16].w;
COS R3.w, R1.z;
SIN R3.z, R2.y;
FRC R3.zw, R3;
ABS R1.z, R3.w;
ABS R2.y, R3.z;
MAX R4.x, R2.y, R1.z;
SLT R4.y, R4.x, c[13].x;
MUL R3.w, R3.y, c[16].x;
MUL R1.y, R1, c[15].x;
POW R1.z, c[14].w, R1.y;
SLT R1.y, c[5].x, R1.x;
MUL R2.y, R1, R4;
ABS R2.z, R4.y;
MUL R3.z, R3.y, c[16];
CMP R2.y, -R2, R4.x, c[13].x;
MAD R4.z, R3.x, c[15].w, R3.w;
MAD R3.z, R3.x, c[16].y, R3;
COS R3.w, R3.z;
SIN R3.z, R4.z;
FRC R3.zw, R3;
CMP R2.z, -R2, c[5].x, R1.w;
MUL R4.z, R1.y, R2;
ABS R2.z, R3.w;
ABS R3.z, R3;
MAX R2.z, R3, R2;
SLT R4.w, R2.z, R2.y;
MUL R3.z, R4.y, R4;
MUL R4.z, R1.y, R4.w;
CMP R3.z, -R3, R4.x, c[13].x;
CMP R4.x, -R4.z, R2.y, R3.z;
ABS R3.w, R4;
CMP R3.z, -R3.w, c[5].x, R1.w;
MUL R4.w, R1.y, R3.z;
ADD R3.zw, R3.xyxy, c[7].xywy;
SLT R4.y, R2.z, R4.x;
MUL R4.y, R4.w, R4;
CMP R2.y, -R4.z, R2.z, R2;
CMP R2.z, -R4.y, R2, R4.x;
MUL R4.w, R3, c[16].z;
MUL R5.y, R3.w, c[16].x;
MAD R3.w, R3.z, c[16].y, R4;
MAD R3.z, R3, c[15].w, R5.y;
COS R3.w, R3.w;
SIN R3.z, R3.z;
FRC R3.zw, R3;
ABS R3.w, R3;
ABS R3.z, R3;
MAX R4.z, R3, R3.w;
SLT R3.w, R4.z, R2.y;
MUL R4.y, R1, R3.w;
CMP R2.z, -R4.y, R2.y, R2;
ABS R3.z, R3.w;
CMP R3.z, -R3, c[5].x, R1.w;
MUL R4.w, R1.y, R3.z;
ADD R3.zw, R3.xyxy, c[17].xyxy;
SLT R4.x, R4.z, R2.z;
MUL R4.x, R4.w, R4;
CMP R2.y, -R4, R4.z, R2;
MUL R4.w, R3, c[16].z;
MUL R5.y, R3.w, c[16].x;
MAD R3.w, R3.z, c[16].y, R4;
MAD R3.z, R3, c[15].w, R5.y;
CMP R2.z, -R4.x, R4, R2;
COS R3.w, R3.w;
SIN R3.z, R3.z;
FRC R3.zw, R3;
ABS R3.w, R3;
ABS R3.z, R3;
MAX R4.y, R3.z, R3.w;
SLT R3.w, R4.y, R2.y;
MUL R4.z, R1.y, R3.w;
CMP R2.z, -R4, R2.y, R2;
ABS R3.z, R3.w;
CMP R3.z, -R3, c[5].x, R1.w;
MUL R4.w, R1.y, R3.z;
ADD R3.zw, R3.xyxy, c[7].xyyw;
SLT R4.x, R4.y, R2.z;
MUL R4.x, R4.w, R4;
ADD R3.xy, R3, c[7].w;
CMP R2.y, -R4.z, R4, R2;
CMP R2.z, -R4.x, R4.y, R2;
MUL R4.w, R3, c[16].z;
MUL R5.y, R3.w, c[16].x;
MAD R3.w, R3.z, c[16].y, R4;
MAD R3.z, R3, c[15].w, R5.y;
COS R3.w, R3.w;
SIN R3.z, R3.z;
FRC R3.zw, R3;
ABS R3.w, R3;
ABS R3.z, R3;
MAX R3.z, R3, R3.w;
SLT R3.w, R3.z, R2.y;
ABS R4.y, R3.w;
MUL R3.w, R1.y, R3;
CMP R4.x, -R3.w, R2.y, R2.z;
CMP R2.y, -R3.w, R3.z, R2;
CMP R4.y, -R4, c[5].x, R1.w;
ABS R3.w, R0.z;
SLT R2.z, R3, R4.x;
MUL R4.y, R1, R4;
MUL R2.z, R4.y, R2;
CMP R2.z, -R2, R3, R4.x;
MUL R4.x, R3.y, c[16].z;
MUL R4.y, R3, c[16].x;
MAD R3.y, R3.x, c[16], R4.x;
MAD R3.x, R3, c[15].w, R4.y;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R3.z, R3.x, R3.y;
ABS R3.x, R0;
MAX R3.y, R3.x, R3.w;
MIN R4.x, R3, R3.w;
ADD R3.x, R3, -R3.w;
RCP R3.y, R3.y;
MUL R4.x, R4, R3.y;
MUL R4.y, R4.x, R4.x;
SLT R4.w, R3.z, R2.y;
MUL R3.y, R1, R4.w;
CMP R2.z, -R3.y, R2.y, R2;
CMP R2.y, -R3, R3.z, R2;
MAD R5.y, R4, c[10].x, c[10];
MAD R5.y, R5, R4, -c[10].z;
MAD R5.y, R5, R4, c[10].w;
MAD R5.y, R5, R4, -c[11].x;
MAD R4.y, R5, R4, c[11];
ABS R4.w, R4;
CMP R4.w, -R4, c[5].x, R1;
SLT R4.z, R3, R2;
MUL R1.y, R1, R4.w;
MUL R1.y, R1, R4.z;
CMP R1.y, -R1, R3.z, R2.z;
MUL R4.x, R4.y, R4;
ADD R2.z, -R4.x, c[9].w;
CMP R3.x, -R3, R2.z, R4;
ADD R2.z, -R3.x, c[9];
ADD R1.y, R1, -R2;
ADD R1.y, R1, -c[16].w;
MUL R1.y, R1, c[15].x;
CMP R3.x, R0.z, R2.z, R3;
MOV R3.y, c[11].w;
MUL R2.z, R3.y, c[4].x;
CMP R3.y, R0.x, -R3.x, R3.x;
MAD R3.x, R3.y, c[13].z, R2.z;
FLR R2.y, R3.x;
MAD R3.x, R3.y, c[11].z, R2.z;
MAD R2.z, R3.y, c[13].x, -R2;
MUL R2.y, R2, c[12].x;
SIN R2.y, R2.y;
FLR R3.x, R3;
FLR R2.z, R2;
MUL R3.x, R3, c[12];
MUL R2.z, R2, c[12].x;
SIN R3.x, R3.x;
MUL R3.x, R3, c[12].y;
SIN R2.z, R2.z;
MUL R2.z, R2, c[12].y;
FRC R3.y, R3.x;
FRC R2.z, R2;
MUL R3.x, R2.z, c[13].y;
MOV R3.z, c[3].x;
MAD R2.z, R3, c[12].w, c[12];
MAD R2.z, R3.y, R2, R3.x;
MUL R2.y, R2, c[12];
FRC R3.x, R2.y;
MAD R2.z, R3.x, c[13].w, R2;
ABS R3.x, R0.y;
ADD R3.y, R1.w, -c[3].x;
MUL R2.y, R0, R0;
MUL R2.y, R2, R3;
MUL R3.w, -R2, c[18].x;
POW R2.z, R2.z, c[14].x;
RCP R2.y, R2.y;
MUL R2.y, R2.z, R2;
MAD R2.z, R3.y, c[9].y, c[9].x;
ADD R3.x, -R3, c[7].w;
POW R2.z, R3.x, R2.z;
MAD R2.y, R2, c[14], R2.z;
MUL R2.y, R2, c[14].z;
POW R1.y, c[14].w, R1.y;
MAD R1.y, R1, c[14], R2;
CMP R2.z, -R1.x, R1.y, R2.y;
MAD R1.z, R1, c[14].y, R2;
ADD R3.y, R5.x, c[2].x;
MOV R3.xz, c[5].x;
ADD R3.xyz, -R3, c[0];
MUL R4.xyz, -R3.zxyw, c[7].yyww;
MAD R4.xyz, R3.yzxw, c[7].ywyw, R4;
DP3 R4.y, R0, R4;
MUL R5.xyz, -R3.yzxw, c[7].wyyw;
MAD R5.xyz, R3.zxyw, c[7].ywyw, R5;
DP3 R4.z, R0, R5;
DP3 R4.x, R3, c[8].yzyw;
MUL R3.xyz, R0.w, R4;
MAD R4.xy, R3.yzzw, c[17].w, R3.w;
FLR R4.xy, R4;
ADD R4.zw, R4.xyxy, c[8].xyzy;
CMP R3.y, -R2.x, R1.z, R2.z;
MUL R1.y, R4.w, c[16].x;
MUL R1.x, R4.w, c[16].z;
SLT R1.z, c[5].x, R3.x;
MAD R2.y, R4.z, c[15].w, R1;
MAD R1.x, R4.z, c[16].y, R1;
COS R1.y, R1.x;
SIN R1.x, R2.y;
FRC R1.xy, R1;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R2.y, R1.x, R1;
SLT R3.z, R2.y, c[13].x;
MUL R1.y, R1.z, R3.z;
CMP R2.x, -R1.y, R2.y, c[13];
ABS R1.x, R3.z;
CMP R2.z, -R1.x, c[5].x, R1.w;
MUL R1.y, R4, c[16].x;
MUL R1.x, R4.y, c[16].z;
MAD R4.z, R4.x, c[15].w, R1.y;
MAD R1.x, R4, c[16].y, R1;
COS R1.y, R1.x;
SIN R1.x, R4.z;
FRC R1.xy, R1;
MUL R4.z, R1, R2;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R2.z, R1.x, R1.y;
SLT R4.w, R2.z, R2.x;
MUL R1.x, R3.z, R4.z;
CMP R1.x, -R1, R2.y, c[13];
MUL R2.y, R1.z, R4.w;
CMP R3.z, -R2.y, R2.x, R1.x;
ABS R1.y, R4.w;
CMP R1.x, -R1.y, c[5], R1.w;
MUL R4.w, R1.z, R1.x;
ADD R1.xy, R4, c[7].wyzw;
SLT R4.z, R2, R3;
MUL R4.z, R4.w, R4;
CMP R2.x, -R2.y, R2.z, R2;
MUL R4.w, R1.y, c[16].z;
MUL R5.x, R1.y, c[16];
MAD R1.y, R1.x, c[16], R4.w;
MAD R1.x, R1, c[15].w, R5;
COS R1.y, R1.y;
SIN R1.x, R1.x;
FRC R1.xy, R1;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R2.y, R1.x, R1;
SLT R4.w, R2.y, R2.x;
CMP R1.x, -R4.z, R2.z, R3.z;
MUL R2.z, R1, R4.w;
CMP R3.z, -R2, R2.x, R1.x;
ABS R1.y, R4.w;
CMP R1.x, -R1.y, c[5], R1.w;
MUL R4.w, R1.z, R1.x;
ADD R1.xy, R4, c[17];
SLT R4.z, R2.y, R3;
MUL R4.z, R4.w, R4;
CMP R2.x, -R2.z, R2.y, R2;
MUL R4.w, R1.y, c[16].z;
MUL R5.x, R1.y, c[16];
MAD R1.y, R1.x, c[16], R4.w;
MAD R1.x, R1, c[15].w, R5;
COS R1.y, R1.y;
SIN R1.x, R1.x;
FRC R1.xy, R1;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R2.z, R1.x, R1.y;
SLT R4.w, R2.z, R2.x;
CMP R1.x, -R4.z, R2.y, R3.z;
MUL R2.y, R1.z, R4.w;
CMP R3.z, -R2.y, R2.x, R1.x;
ABS R1.y, R4.w;
CMP R1.x, -R1.y, c[5], R1.w;
MUL R4.w, R1.z, R1.x;
ADD R1.xy, R4, c[7].ywzw;
SLT R4.z, R2, R3;
MUL R4.z, R4.w, R4;
CMP R2.y, -R2, R2.z, R2.x;
MUL R4.w, R1.y, c[16].z;
MUL R5.x, R1.y, c[16];
MAD R1.y, R1.x, c[16], R4.w;
MAD R1.x, R1, c[15].w, R5;
COS R1.y, R1.y;
SIN R1.x, R1.x;
FRC R1.xy, R1;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R2.x, R1, R1.y;
SLT R4.w, R2.x, R2.y;
CMP R1.x, -R4.z, R2.z, R3.z;
MUL R3.z, R1, R4.w;
CMP R2.z, -R3, R2.y, R1.x;
ABS R1.y, R4.w;
CMP R1.x, -R1.y, c[5], R1.w;
MUL R4.w, R1.z, R1.x;
ADD R1.xy, R4, c[7].w;
SLT R4.z, R2.x, R2;
MUL R4.x, R4.w, R4.z;
CMP R3.z, -R3, R2.x, R2.y;
MUL R4.y, R1, c[16].z;
MUL R4.z, R1.y, c[16].x;
MAD R1.y, R1.x, c[16], R4;
MAD R1.x, R1, c[15].w, R4.z;
COS R1.y, R1.y;
SIN R1.x, R1.x;
FRC R1.xy, R1;
ABS R1.y, R1;
ABS R1.x, R1;
MAX R4.w, R1.x, R1.y;
SLT R2.y, R4.w, R3.z;
CMP R1.x, -R4, R2, R2.z;
MUL R5.w, R1.z, R2.y;
CMP R4.x, -R5.w, R3.z, R1;
ABS R1.y, R2;
CMP R1.y, -R1, c[5].x, R1.w;
SLT R1.x, R4.w, R4;
MUL R1.y, R1.z, R1;
MUL R4.y, R1, R1.x;
MOV R1.xyz, c[5].yzww;
ADD R2.y, R1.z, c[2].x;
MOV R2.xz, c[5].x;
ADD R2.xyz, -R2, c[0];
CMP R1.z, -R4.y, R4.w, R4.x;
CMP R3.z, -R5.w, R4.w, R3;
ADD R1.z, R1, -R3;
MUL R4.xyz, -R2.zxyw, c[7].yyww;
MAD R4.xyz, R2.yzxw, c[7].ywyw, R4;
DP3 R4.y, R0, R4;
MUL R5.xyz, -R2.yzxw, c[7].wyyw;
MAD R5.xyz, R2.zxyw, c[7].ywyw, R5;
ADD R1.z, R1, -c[16].w;
DP3 R4.z, R0, R5;
DP3 R4.x, R2, c[8].yzyw;
MUL R2.xyz, R0.w, R4;
MUL R4.xy, R2.yzzw, c[18].y;
FLR R4.xy, R4;
ADD R4.zw, R4.xyxy, c[8].xyzy;
MUL R2.y, R4.w, c[16].z;
MUL R2.z, R4.w, c[16].x;
MAD R2.y, R4.z, c[16], R2;
MAD R2.z, R4, c[15].w, R2;
MUL R1.z, R1, c[15].x;
SIN R4.z, R2.z;
COS R4.w, R2.y;
FRC R4.zw, R4;
POW R2.z, c[14].w, R1.z;
ABS R1.z, R4.w;
ABS R2.y, R4.z;
MAX R5.x, R2.y, R1.z;
SLT R5.y, R5.x, c[13].x;
MUL R4.w, R4.y, c[16].x;
ABS R3.z, R5.y;
MUL R4.z, R4.y, c[16];
SLT R1.z, c[5].x, R2.x;
MAD R2.y, R2.z, c[14], R3;
MUL R2.z, R1, R5.y;
CMP R2.z, -R2, R5.x, c[13].x;
MAD R5.z, R4.x, c[15].w, R4.w;
MAD R4.z, R4.x, c[16].y, R4;
COS R4.w, R4.z;
SIN R4.z, R5.z;
FRC R4.zw, R4;
CMP R3.z, -R3, c[5].x, R1.w;
MUL R5.z, R1, R3;
MUL R5.y, R5, R5.z;
CMP R5.y, -R5, R5.x, c[13].x;
ABS R3.z, R4.w;
ABS R4.z, R4;
MAX R3.z, R4, R3;
SLT R4.w, R3.z, R2.z;
MUL R5.x, R1.z, R4.w;
CMP R5.y, -R5.x, R2.z, R5;
ABS R4.z, R4.w;
CMP R4.z, -R4, c[5].x, R1.w;
MUL R5.w, R1.z, R4.z;
SLT R5.z, R3, R5.y;
ADD R4.zw, R4.xyxy, c[7].xywy;
MUL R5.z, R5.w, R5;
MUL R5.w, R4, c[16].z;
CMP R2.z, -R5.x, R3, R2;
MAD R5.w, R4.z, c[16].y, R5;
MUL R4.w, R4, c[16].x;
MAD R4.z, R4, c[15].w, R4.w;
COS R4.w, R5.w;
SIN R4.z, R4.z;
FRC R4.zw, R4;
ABS R4.w, R4;
ABS R4.z, R4;
MAX R5.x, R4.z, R4.w;
SLT R5.w, R5.x, R2.z;
CMP R4.z, -R5, R3, R5.y;
MUL R3.z, R1, R5.w;
CMP R5.y, -R3.z, R2.z, R4.z;
ABS R4.w, R5;
CMP R4.z, -R4.w, c[5].x, R1.w;
MUL R5.w, R1.z, R4.z;
SLT R5.z, R5.x, R5.y;
ADD R4.zw, R4.xyxy, c[17].xyxy;
MUL R5.z, R5.w, R5;
MUL R5.w, R4, c[16].z;
CMP R2.z, -R3, R5.x, R2;
MAD R5.w, R4.z, c[16].y, R5;
MUL R4.w, R4, c[16].x;
MAD R4.z, R4, c[15].w, R4.w;
COS R4.w, R5.w;
SIN R4.z, R4.z;
FRC R4.zw, R4;
ABS R3.z, R4.w;
ABS R4.z, R4;
MAX R3.z, R4, R3;
SLT R5.w, R3.z, R2.z;
CMP R4.z, -R5, R5.x, R5.y;
MUL R5.y, R1.z, R5.w;
CMP R5.x, -R5.y, R2.z, R4.z;
ABS R4.w, R5;
CMP R4.z, -R4.w, c[5].x, R1.w;
MUL R5.w, R1.z, R4.z;
ADD R4.zw, R4.xyxy, c[7].xyyw;
SLT R5.z, R3, R5.x;
MUL R5.z, R5.w, R5;
MUL R5.w, R4, c[16].z;
CMP R2.z, -R5.y, R3, R2;
ADD R4.xy, R4, c[7].w;
CMP R3.z, -R5, R3, R5.x;
MUL R5.z, R4.y, c[16].x;
MUL R4.w, R4, c[16].x;
MAD R5.w, R4.z, c[16].y, R5;
MAD R4.z, R4, c[15].w, R4.w;
COS R4.w, R5.w;
SIN R4.z, R4.z;
FRC R4.zw, R4;
ABS R4.w, R4;
ABS R4.z, R4;
MAX R4.z, R4, R4.w;
SLT R4.w, R4.z, R2.z;
ABS R5.x, R4.w;
MUL R4.w, R1.z, R4;
CMP R3.z, -R4.w, R2, R3;
CMP R5.y, -R5.x, c[5].x, R1.w;
CMP R2.z, -R4.w, R4, R2;
SLT R5.x, R4.z, R3.z;
MUL R5.y, R1.z, R5;
MUL R5.x, R5.y, R5;
MUL R5.y, R4, c[16].z;
MAD R4.y, R4.x, c[16], R5;
MAD R4.x, R4, c[15].w, R5.z;
CMP R3.z, -R5.x, R4, R3;
COS R4.y, R4.y;
SIN R4.x, R4.x;
FRC R4.xy, R4;
ABS R4.y, R4;
ABS R4.x, R4;
MAX R4.x, R4, R4.y;
SLT R4.y, R4.x, R2.z;
ABS R4.w, R4.y;
MUL R4.y, R1.z, R4;
CMP R4.z, -R4.y, R2, R3;
CMP R4.w, -R4, c[5].x, R1;
MUL R1.z, R1, R4.w;
SLT R3.z, R4.x, R4;
MUL R3.z, R1, R3;
CMP R1.z, -R3.x, R2.y, R3.y;
CMP R2.y, -R3.z, R4.x, R4.z;
ADD R3.y, R1, c[2].x;
CMP R1.y, -R4, R4.x, R2.z;
ADD R1.y, R2, -R1;
MOV R3.xz, c[5].x;
ADD R3.xyz, -R3, c[0];
MUL R4.xyz, -R3.zxyw, c[7].yyww;
MAD R4.xyz, R3.yzxw, c[7].ywyw, R4;
DP3 R4.y, R0, R4;
MUL R5.xyz, -R3.yzxw, c[7].wyyw;
MAD R5.xyz, R3.zxyw, c[7].ywyw, R5;
ADD R1.y, R1, -c[16].w;
MUL R1.y, R1, c[15].x;
POW R2.z, c[14].w, R1.y;
DP3 R4.z, R0, R5;
DP3 R4.x, R3, c[8].yzyw;
MUL R3.xyz, R0.w, R4;
MAD R3.zw, R3.xyyz, c[18].z, -R3.w;
FLR R3.zw, R3;
ADD R4.xy, R3.zwzw, c[8].zyzw;
MAD R2.z, R2, c[14].y, R1;
MUL R1.y, R4, c[16].z;
MUL R2.y, R4, c[16].x;
MAD R1.y, R4.x, c[16], R1;
MAD R2.y, R4.x, c[15].w, R2;
CMP R3.y, -R2.x, R2.z, R1.z;
COS R4.y, R1.y;
SIN R4.x, R2.y;
FRC R4.xy, R4;
ABS R2.y, R4.x;
ABS R1.y, R4;
MAX R4.y, R2, R1;
SLT R1.z, R4.y, c[13].x;
SLT R4.x, c[5], R3;
MUL R1.y, R4.x, R1.z;
ABS R2.x, R1.z;
CMP R2.z, -R2.x, c[5].x, R1.w;
MUL R2.y, R3.w, c[16].x;
MUL R2.x, R3.w, c[16].z;
CMP R1.y, -R1, R4, c[13].x;
MAD R4.z, R3, c[15].w, R2.y;
MAD R2.x, R3.z, c[16].y, R2;
COS R2.y, R2.x;
SIN R2.x, R4.z;
FRC R2.xy, R2;
MUL R4.z, R4.x, R2;
MUL R1.z, R1, R4;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.z, R2.x, R2.y;
SLT R4.w, R2.z, R1.y;
CMP R2.x, -R1.z, R4.y, c[13];
MUL R1.z, R4.x, R4.w;
CMP R4.y, -R1.z, R1, R2.x;
ABS R2.y, R4.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R4.w, R4.x, R2.x;
ADD R2.xy, R3.zwzw, c[7].wyzw;
SLT R4.z, R2, R4.y;
MUL R4.z, R4.w, R4;
CMP R1.y, -R1.z, R2.z, R1;
MUL R4.w, R2.y, c[16].z;
MUL R5.x, R2.y, c[16];
MAD R2.y, R2.x, c[16], R4.w;
MAD R2.x, R2, c[15].w, R5;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R1.z, R2.y;
ABS R2.x, R2;
MAX R1.z, R2.x, R1;
SLT R4.w, R1.z, R1.y;
CMP R2.x, -R4.z, R2.z, R4.y;
MUL R2.z, R4.x, R4.w;
CMP R4.y, -R2.z, R1, R2.x;
ABS R2.y, R4.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R4.w, R4.x, R2.x;
ADD R2.xy, R3.zwzw, c[17];
SLT R4.z, R1, R4.y;
MUL R4.z, R4.w, R4;
CMP R1.y, -R2.z, R1.z, R1;
MUL R4.w, R2.y, c[16].z;
MUL R5.x, R2.y, c[16];
MAD R2.y, R2.x, c[16], R4.w;
MAD R2.x, R2, c[15].w, R5;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.z, R2.x, R2.y;
SLT R4.w, R2.z, R1.y;
CMP R2.x, -R4.z, R1.z, R4.y;
MUL R1.z, R4.x, R4.w;
CMP R4.y, -R1.z, R1, R2.x;
ABS R2.y, R4.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R4.w, R4.x, R2.x;
ADD R2.xy, R3.zwzw, c[7].ywzw;
SLT R4.z, R2, R4.y;
MUL R4.z, R4.w, R4;
CMP R1.z, -R1, R2, R1.y;
MUL R4.w, R2.y, c[16].z;
MUL R5.x, R2.y, c[16];
MAD R2.y, R2.x, c[16], R4.w;
MAD R2.x, R2, c[15].w, R5;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R1.y, R2;
ABS R2.x, R2;
MAX R1.y, R2.x, R1;
SLT R4.w, R1.y, R1.z;
CMP R2.x, -R4.z, R2.z, R4.y;
MUL R4.y, R4.x, R4.w;
CMP R2.z, -R4.y, R1, R2.x;
ABS R2.y, R4.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R4.w, R4.x, R2.x;
ADD R2.xy, R3.zwzw, c[7].w;
SLT R4.z, R1.y, R2;
MUL R4.z, R4.w, R4;
MUL R3.z, R2.y, c[16];
MUL R3.w, R2.y, c[16].x;
MAD R2.y, R2.x, c[16], R3.z;
CMP R3.z, -R4.y, R1.y, R1;
MAD R2.x, R2, c[15].w, R3.w;
CMP R1.y, -R4.z, R1, R2.z;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R1.z, R2.y;
ABS R2.x, R2;
MAX R3.w, R2.x, R1.z;
SLT R1.z, R3.w, R3;
MUL R4.w, R4.x, R1.z;
CMP R5.x, -R4.w, R3.z, R1.y;
ABS R1.y, R1.z;
CMP R4.y, -R1, c[5].x, R1.w;
ADD R2.y, R1.x, c[2].x;
MOV R2.xz, c[5].x;
ADD R1.xyz, -R2, c[0];
MUL R2.xyz, -R1.zxyw, c[7].yyww;
MAD R2.xyz, R1.yzxw, c[7].ywyw, R2;
DP3 R2.y, R2, R0;
MUL R5.z, R4.x, R4.y;
MUL R4.xyz, -R1.yzxw, c[7].wyyw;
MAD R4.xyz, R1.zxyw, c[7].ywyw, R4;
DP3 R2.x, R1, c[8].yzyw;
DP3 R2.z, R0, R4;
MUL R0.xyz, R2, R0.w;
MUL R1.x, R2.w, c[7].z;
MAD R0.zw, R0.xyyz, c[18].w, R1.x;
FLR R0.zw, R0;
SLT R5.y, R3.w, R5.x;
MUL R0.y, R5.z, R5;
ADD R1.xy, R0.zwzw, c[8].zyzw;
CMP R2.x, -R0.y, R3.w, R5;
MUL R0.y, R1, c[16].z;
CMP R1.z, -R4.w, R3.w, R3;
ADD R1.z, R2.x, -R1;
MUL R2.y, R0.w, c[16].x;
MUL R2.x, R0.w, c[16].z;
MAD R3.z, R0, c[15].w, R2.y;
MAD R2.x, R0.z, c[16].y, R2;
COS R2.y, R2.x;
SIN R2.x, R3.z;
FRC R2.xy, R2;
MAD R0.y, R1.x, c[16], R0;
MUL R1.y, R1, c[16].x;
MAD R1.x, R1, c[15].w, R1.y;
COS R1.y, R0.y;
SIN R1.x, R1.x;
FRC R1.xy, R1;
ABS R0.y, R1;
ABS R1.x, R1;
MAX R2.z, R1.x, R0.y;
SLT R1.x, c[5], R0;
SLT R2.w, R2.z, c[13].x;
ADD R0.y, R1.z, -c[16].w;
MUL R1.y, R1.x, R2.w;
ABS R1.z, R2.w;
CMP R1.z, -R1, c[5].x, R1.w;
MUL R3.z, R1.x, R1;
CMP R1.y, -R1, R2.z, c[13].x;
ABS R1.z, R2.y;
ABS R2.x, R2;
MAX R1.z, R2.x, R1;
SLT R3.w, R1.z, R1.y;
MUL R2.x, R2.w, R3.z;
CMP R2.x, -R2, R2.z, c[13];
MUL R2.z, R1.x, R3.w;
CMP R2.w, -R2.z, R1.y, R2.x;
ABS R2.y, R3.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R3.w, R1.x, R2.x;
ADD R2.xy, R0.zwzw, c[7].wyzw;
SLT R3.z, R1, R2.w;
MUL R3.z, R3.w, R3;
CMP R1.y, -R2.z, R1.z, R1;
MUL R3.w, R2.y, c[16].z;
MUL R4.x, R2.y, c[16];
MAD R2.y, R2.x, c[16], R3.w;
MAD R2.x, R2, c[15].w, R4;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.z, R2.x, R2.y;
SLT R3.w, R2.z, R1.y;
CMP R2.x, -R3.z, R1.z, R2.w;
MUL R1.z, R1.x, R3.w;
CMP R2.w, -R1.z, R1.y, R2.x;
ABS R2.y, R3.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R3.w, R1.x, R2.x;
ADD R2.xy, R0.zwzw, c[17];
SLT R3.z, R2, R2.w;
MUL R3.z, R3.w, R3;
CMP R1.y, -R1.z, R2.z, R1;
MUL R3.w, R2.y, c[16].z;
MUL R4.x, R2.y, c[16];
MAD R2.y, R2.x, c[16], R3.w;
MAD R2.x, R2, c[15].w, R4;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R1.z, R2.y;
ABS R2.x, R2;
MAX R1.z, R2.x, R1;
SLT R3.w, R1.z, R1.y;
CMP R2.x, -R3.z, R2.z, R2.w;
MUL R2.w, R1.x, R3;
CMP R2.z, -R2.w, R1.y, R2.x;
ABS R2.y, R3.w;
CMP R2.x, -R2.y, c[5], R1.w;
MUL R3.w, R1.x, R2.x;
ADD R2.xy, R0.zwzw, c[7].ywzw;
SLT R3.z, R1, R2;
MUL R3.z, R3.w, R3;
CMP R1.y, -R2.w, R1.z, R1;
ADD R0.zw, R0, c[7].w;
CMP R1.z, -R3, R1, R2;
MUL R4.x, R2.y, c[16];
MUL R3.w, R2.y, c[16].z;
MAD R2.y, R2.x, c[16], R3.w;
MAD R2.x, R2, c[15].w, R4;
MUL R3.z, R0.w, c[16].x;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.x, R2, R2.y;
SLT R2.y, R2.x, R1;
ABS R2.z, R2.y;
MUL R2.y, R1.x, R2;
CMP R1.z, -R2.y, R1.y, R1;
CMP R2.w, -R2.z, c[5].x, R1;
CMP R2.y, -R2, R2.x, R1;
SLT R2.z, R2.x, R1;
MUL R2.w, R1.x, R2;
MUL R2.z, R2.w, R2;
MUL R2.w, R0, c[16].z;
MAD R0.w, R0.z, c[16].y, R2;
MAD R0.z, R0, c[15].w, R3;
COS R0.w, R0.w;
SIN R0.z, R0.z;
FRC R0.zw, R0;
ABS R0.w, R0;
ABS R0.z, R0;
MAX R2.w, R0.z, R0;
SLT R1.y, R2.w, R2;
CMP R0.z, -R2, R2.x, R1;
ABS R0.w, R1.y;
MUL R1.z, R1.x, R1.y;
CMP R1.y, -R1.z, R2, R0.z;
CMP R0.w, -R0, c[5].x, R1;
SLT R0.z, R2.w, R1.y;
MUL R0.w, R1.x, R0;
MUL R0.w, R0, R0.z;
CMP R0.w, -R0, R2, R1.y;
CMP R0.z, -R1, R2.w, R2.y;
ADD R0.z, R0.w, -R0;
MUL R0.w, R0.y, c[15].x;
ADD R0.y, R0.z, -c[16].w;
POW R0.z, c[14].w, R0.w;
MAD R0.z, R0, c[14].y, R3.y;
MUL R0.y, R0, c[15].x;
CMP R0.z, -R3.x, R0, R3.y;
POW R0.y, c[14].w, R0.y;
MAD R0.y, R0, c[14], R0.z;
CMP R0.x, -R0, R0.y, R0.z;
MUL result.color.xyz, R0.x, c[1];
MOV result.depth.z, c[8].x;
MOV result.color.w, c[5].x;
END
# 932 instructions, 6 R-regs
"
}
SubProgram "d3d9 " {
// Stats: 274 math, 11 branches
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [iPrimaryColor]
Float 2 [iFloorHeight]
Float 3 [iIntensity]
Float 4 [iIntensityTime]
"ps_3_0
def c5, -0.01348047, 0.05747731, -0.12123910, 0.19563590
def c6, -0.33299461, 0.99999559, 1.57079601, 3.14159298
def c7, 1.70000005, 16.00000000, 1.76821101, 0.50000000
def c8, 6.28318501, -3.14159298, 547.89001465, 4.00000000
def c9, 0.69999999, -0.20000000, 8.00000000, 0.25000000
def c10, 0.12500000, 5.00000000, 1.00000000, 0.10000000
def c11, 30.00000000, 11.00000000, 3.00000000, 0.00000000
defi i0, 6, 0, 1, 0
def c12, -15000.00000000, -5000.00000000, 0.00000000, -1.00000000
def c13, 0.00000000, 1.00000000, 0.00030000, 0.00010000
def c14, 180.00000000, -3.00000000, 4.40000010, 100.00000000
defi i1, 255, 0, 1, 0
def c15, 500.00000000, 0.15915491, 0.50000000, 48.00000000
def c16, 250.00000000, -0.02000000, -100.00000000, 2.71828198
def c17, 0.99989998, 0, 0, 0
dcl_texcoord1 v0.xyz
add r0.xyz, v0, -c0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
abs r0.y, r1.z
abs r0.x, r1
max r0.z, r0.x, r0.y
rcp r0.w, r0.z
min r0.z, r0.x, r0.y
mul r0.z, r0, r0.w
mul r0.w, r0.z, r0.z
mad r1.w, r0, c5.x, c5.y
mad r1.w, r1, r0, c5.z
mad r1.w, r1, r0, c5
mad r1.w, r1, r0, c6.x
mad r0.w, r1, r0, c6.y
mul r0.z, r0.w, r0
add r0.w, -r0.z, c6.z
add r0.x, r0, -r0.y
cmp r0.x, -r0, r0.z, r0.w
add r0.y, -r0.x, c6.w
cmp r0.x, r1.z, r0, r0.y
mov r0.z, c4.x
mul r2.y, c7.x, r0.z
cmp r2.x, r1, r0, -r0
mad r0.x, r2, c7.y, r2.y
frc r0.y, r0.x
add r0.x, r0, -r0.y
mad r0.x, r0, c7.z, c7.w
frc r0.x, r0
mad r1.w, r0.x, c8.x, c8.y
sincos r0.xy, r1.w
mad r0.z, r2.x, c9, -r2.y
mul r1.w, r0.y, c8.z
mad r0.x, r2, c8.w, r2.y
frc r0.y, r0.x
add r0.x, r0, -r0.y
frc r0.w, r0.z
add r0.y, r0.z, -r0.w
mad r0.x, r0, c7.z, c7.w
mad r0.y, r0, c7.z, c7.w
frc r0.y, r0
frc r0.x, r0
mad r0.x, r0, c8, c8.y
sincos r2.xy, r0.x
mad r3.x, r0.y, c8, c8.y
sincos r0.xy, r3.x
mul r0.x, r2.y, c8.z
mul r0.y, r0, c8.z
frc r0.z, r0.y
mov r0.y, c3.x
frc r0.x, r0
mul r0.z, r0, c9.w
mad r0.y, r0, c9.x, c9
mad r0.y, r0.x, r0, r0.z
frc r0.x, r1.w
mad r1.w, r0.x, c10.x, r0.y
pow r0, r1.w, c10.y
mov r2.y, r0.x
mov r0.x, c3
add r2.x, c10.z, -r0
abs r0.x, r1.y
mul r1.w, r1.y, r1.y
mad r2.w, r2.x, c11.x, c11.y
add r2.z, -r0.x, c10
pow r0, r2.z, r2.w
mul r0.y, r1.w, r2.x
mov r0.z, r0.x
rcp r0.y, r0.y
mul r0.x, r2.y, r0.y
mad r0.x, r0, c10.w, r0.z
mul r1.w, r0.x, c11.z
mov r3.z, c11.w
loop aL, i0
mul r0.x, r3.z, c12
add r0.y, r0.x, c2.x
mov r0.xz, c11.w
add r0.y, r0, c12
add r0.xyz, -r0, c0
mul r2.xyz, -r0.zxyw, c13.xxyw
mad r2.xyz, r0.yzxw, c13.xyxw, r2
dp3 r2.y, r2, r1
mul r4.xyz, -r0.yzxw, c13.yxxw
mad r4.xyz, r0.zxyw, c13.xyxw, r4
dp3 r2.z, r1, r4
rcp r0.w, r1.y
dp3 r2.x, r0, c12.zwzw
mul r0.xyz, r2, r0.w
if_gt r0.x, c11.w
mov r0.x, c4
add r0.w, r3.z, c14.y
add r0.x, c14, r0
mul r0.x, r0, r0.w
mul r0.w, r0.x, c14.z
mad r0.x, r3.z, c13.z, c13.w
mad r0.xy, r0.yzzw, r0.x, r0.w
frc r0.zw, r0.xyxy
add r3.xy, r0, -r0.zwzw
mov r4.x, c9.z
mov r4.w, c9.z
mov r3.w, c11
loop aL, i1
break_gt r3.w, c10.z
mov r0.y, r3.w
mov r0.x, c12.w
add r0.xy, r3, r0
mul r0.z, r0.y, c15.w
mad r0.z, r0.x, c16.x, r0
mul r0.y, r0, c14.w
mad r0.x, r0, c15, r0.y
mad r0.y, r0.z, c15, c15.z
frc r0.y, r0
mad r0.x, r0, c15.y, c15.z
frc r0.x, r0
mad r2.x, r0.y, c8, c8.y
mad r4.y, r0.x, c8.x, c8
sincos r0.xy, r2.x
sincos r2.xy, r4.y
mov r0.y, r0.x
mov r0.x, r2.y
frc r0.xy, r0
abs r0.y, r0
abs r0.x, r0
max r4.y, r0.x, r0
add r4.z, r4.y, -r4.x
cmp r0.z, r4, r4.w, r4.x
add r0.x, r4.y, -r4
add r0.y, r4, -r0.z
cmp r0.x, r0, c13, c13.y
abs_pp r0.x, r0
cmp r0.y, r0, c13.x, c13
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r0.w, r0.x, r0.y
cmp r4.w, -r0, r0.z, r4.y
cmp r4.y, r4.z, r4.x, r4
mov r0.y, r3.w
mov r0.x, c11.w
add r0.xy, r3, r0
mul r0.z, r0.y, c15.w
mad r0.z, r0.x, c16.x, r0
mul r0.y, r0, c14.w
mad r0.x, r0, c15, r0.y
mad r0.y, r0.z, c15, c15.z
frc r0.y, r0
mad r0.x, r0, c15.y, c15.z
frc r0.x, r0
mad r2.x, r0.y, c8, c8.y
mad r5.x, r0, c8, c8.y
sincos r0.xy, r2.x
sincos r2.xy, r5.x
mov r0.y, r0.x
mov r0.x, r2.y
frc r0.xy, r0
abs r0.y, r0
abs r0.x, r0
max r4.x, r0, r0.y
add r4.z, r4.x, -r4.y
cmp r0.z, r4, r4.w, r4.y
add r0.y, r4.x, -r0.z
add r0.x, r4, -r4.y
cmp r0.x, r0, c13, c13.y
abs_pp r0.x, r0
cmp r0.y, r0, c13.x, c13
cmp_pp r0.x, -r0, c13.y, c13
mul_pp r0.w, r0.x, r0.y
mov r0.y, r3.w
mov r0.x, c13.y
add r0.xy, r3, r0
cmp r4.w, -r0, r0.z, r4.x
mul r0.z, r0.y, c15.w
mad r0.z, r0.x, c16.x, r0
mul r0.y, r0, c14.w
mad r0.x, r0, c15, r0.y
mad r0.y, r0.z, c15, c15.z
frc r0.y, r0
mad r0.x, r0, c15.y, c15.z
frc r0.x, r0
mad r2.x, r0.y, c8, c8.y
mad r5.x, r0, c8, c8.y
sincos r0.xy, r2.x
sincos r2.xy, r5.x
cmp r0.z, r4, r4.y, r4.x
mov r0.y, r0.x
mov r0.x, r2.y
frc r0.xy, r0
abs r0.y, r0
abs r0.x, r0
max r0.x, r0, r0.y
add r0.y, r0.x, -r0.z
cmp r2.x, r0.y, r4.w, r0.z
add r0.w, r0.x, -r0.z
cmp r0.w, r0, c13.x, c13.y
add r2.y, r0.x, -r2.x
abs_pp r0.w, r0
cmp r2.y, r2, c13.x, c13
cmp_pp r0.w, -r0, c13.y, c13.x
mul_pp r0.w, r0, r2.y
cmp r4.w, -r0, r2.x, r0.x
cmp r4.x, r0.y, r0.z, r0
add r3.w, r3, c13.y
endloop
add r0.x, r4.w, -r4
add r0.x, r0, c16.y
mul r2.x, r0, c16.z
pow r0, c16.w, r2.x
mad r1.w, r0.x, c10, r1
endif
add r3.z, r3, c10
endloop
mul oC0.xyz, r1.w, c1
mov oC0.w, c11
mov oDepth, c17.x
"
}
SubProgram "d3d11 " {
// Stats: 97 math, 4 branches
ConstBuffer "$Globals" 176
Vector 16 [iPrimaryColor]
Float 32 [iFloorHeight]
Float 36 [iIntensity]
Float 40 [iIntensityTime]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedhchdgnabdkiagfiahhoookbanfkjlpmcabaaaaaaomaoaaaaadaaaaaa
cmaaaaaajmaaaaaaoiaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
eeaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaadiaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaabaoaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcpmanaaaaeaaaaaaahpadaaaafjaaaaaeegiocaaa
aaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaagcbaaaadhcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagfaaaaadbccabaaaabaaaaaagiaaaaac
ahaaaaaaaaaaaaajhcaabaaaaaaaaaaabgbgbaaaacaaaaaabgigcaiaebaaaaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
akaabaiambaaaaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaajbcaabaaaabaaaaaa
bkiacaiaebaaaaaaaaaaaaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaapaebabeaaaaaaaaadaebcpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaabkaabaaaabaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaajccaabaaaabaaaaaackaabaiaibaaaaaaaaaaaaaabkaabaiaibaaaaaa
aaaaaaaadeaaaaajecaabaaaabaaaaaackaabaiaibaaaaaaaaaaaaaabkaabaia
ibaaaaaaaaaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpckaabaaaabaaaaaadiaaaaahccaabaaaabaaaaaackaabaaa
abaaaaaabkaabaaaabaaaaaadiaaaaahecaabaaaabaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadcaaaaajicaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaa
fpkokkdmabeaaaaadgfkkolndcaaaaajicaabaaaabaaaaaackaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaochgdidodcaaaaajicaabaaaabaaaaaackaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaebnkjlodcaaaaajecaabaaaabaaaaaa
ckaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaadiphhpdpdiaaaaahicaabaaa
abaaaaaackaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaajbcaabaaaacaaaaaa
ckaabaiaibaaaaaaaaaaaaaabkaabaiaibaaaaaaaaaaaaaadcaaaaajicaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaamaabeaaaaanlapmjdpabaaaaah
icaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaabaaaaaadcaaaaajccaabaaa
abaaaaaabkaabaaaabaaaaaackaabaaaabaaaaaadkaabaaaabaaaaaadbaaaaai
ecaabaaaabaaaaaackaabaaaaaaaaaaackaabaiaebaaaaaaaaaaaaaaabaaaaah
ecaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaanlapejmaaaaaaaahccaabaaa
abaaaaaackaabaaaabaaaaaabkaabaaaabaaaaaaddaaaaahecaabaaaabaaaaaa
ckaabaaaaaaaaaaabkaabaaaaaaaaaaadeaaaaahicaabaaaabaaaaaackaabaaa
aaaaaaaabkaabaaaaaaaaaaadbaaaaaiecaabaaaabaaaaaackaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabnaaaaaiicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabaaaaahecaabaaaabaaaaaadkaabaaaabaaaaaa
ckaabaaaabaaaaaadhaaaaakccaabaaaabaaaaaackaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaabkaabaaaabaaaaaadiaaaaaiecaabaaaabaaaaaackiacaaa
aaaaaaaaacaaaaaaabeaaaaajkjjnjdpdcaaaaamdcaabaaaacaaaaaafgafbaaa
abaaaaaaaceaaaaaaaaaiaeaaaaaiaebaaaaaaaaaaaaaaaakgakbaaaabaaaaaa
ebaaaaafdcaabaaaacaaaaaaegaabaaaacaaaaaadiaaaaakdcaabaaaacaaaaaa
egaabaaaacaaaaaaaceaaaaaipmcdbebipmcdbebaaaaaaaaaaaaaaaaenaaaaag
dcaabaaaacaaaaaaaanaaaaaegaabaaaacaaaaaadiaaaaakdcaabaaaacaaaaaa
egaabaaaacaaaaaaaceaaaaapgpiaieepgpiaieeaaaaaaaaaaaaaaaabkaaaaaf
dcaabaaaacaaaaaaegaabaaaacaaaaaadcaaaaakicaabaaaabaaaaaabkiacaaa
aaaaaaaaacaaaaaaabeaaaaadddddddpabeaaaaamnmmemlodcaaaaakccaabaaa
abaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaaaebckaabaiaebaaaaaaabaaaaaa
ebaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahccaabaaaabaaaaaa
bkaabaaaabaaaaaaabeaaaaaipmcdbebenaaaaagccaabaaaabaaaaaaaanaaaaa
bkaabaaaabaaaaaadiaaaaahccaabaaaabaaaaaabkaabaaaabaaaaaaabeaaaaa
pgpiaieebkaaaaafccaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahccaabaaa
abaaaaaabkaabaaaabaaaaaaabeaaaaaaaaaiadodcaaaaajccaabaaaabaaaaaa
akaabaaaacaaaaaadkaabaaaabaaaaaabkaabaaaabaaaaaadcaaaaajccaabaaa
abaaaaaabkaabaaaacaaaaaaabeaaaaaaaaaaadobkaabaaaabaaaaaadiaaaaah
ecaabaaaabaaaaaabkaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahecaabaaa
abaaaaaackaabaaaabaaaaaackaabaaaabaaaaaadiaaaaahccaabaaaabaaaaaa
ckaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahecaabaaaabaaaaaaakaabaaa
aaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
ckaabaaaabaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpakaabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaaakaabaaaabaaaaaa
abeaaaaamnmmmmdndkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaeaeaaaaaaaaldcaabaaaabaaaaaaigiacaaaaaaaaaaa
acaaaaaaaceaaaaaaaeajmmfaaaadeedaaaaaaaaaaaaaaaadgaaaaailcaabaaa
acaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaafecaabaaa
abaaaaaadkaabaaaaaaaaaaadgaaaaaficaabaaaabaaaaaaabeaaaaaaaaaaaaa
daaaaaabcbaaaaahbcaabaaaadaaaaaadkaabaaaabaaaaaaabeaaaaaagaaaaaa
adaaaeadakaabaaaadaaaaaaclaaaaafbcaabaaaadaaaaaadkaabaaaabaaaaaa
dcaaaaajecaabaaaacaaaaaaakaabaaaadaaaaaaabeaaaaaaagagkmgakaabaaa
abaaaaaaaaaaaaajpcaabaaaaeaaaaaaegaobaiaebaaaaaaacaaaaaacgijcaaa
abaaaaaaaeaaaaaadgaaaaagbcaabaaaafaaaaaackaabaiaebaaaaaaaeaaaaaa
diaaaaakgcaabaaaadaaaaaafgagbaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaadcaaaaangcaabaaaadaaaaaapganbaaaaeaaaaaaaceaaaaa
aaaaaaaaaaaaiadpaaaaaaaaaaaaaaaafgagbaiaebaaaaaaadaaaaaaapaaaaah
ccaabaaaafaaaaaajgafbaaaadaaaaaaigaabaaaaaaaaaaadiaaaaakgcaabaaa
adaaaaaakgalbaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaa
dcaaaaangcaabaaaadaaaaaaagabbaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaafgagbaiaebaaaaaaadaaaaaaapaaaaahecaabaaaafaaaaaa
ggakbaaaadaaaaaaegaabaaaaaaaaaaaaoaaaaahocaabaaaadaaaaaaagajbaaa
afaaaaaaagaabaaaaaaaaaaadbaaaaahecaabaaaacaaaaaaabeaaaaaaaaaaaaa
bkaabaaaadaaaaaabpaaaeadckaabaaaacaaaaaadcaaaaajecaabaaaacaaaaaa
akaabaaaadaaaaaaabeaaaaafcejjndjabeaaaaabhlhnbdiaaaaaaahbcaabaaa
adaaaaaaakaabaaaadaaaaaaabeaaaaaaaaaeamadiaaaaahbcaabaaaadaaaaaa
bkaabaaaabaaaaaaakaabaaaadaaaaaadiaaaaahbcaabaaaadaaaaaaakaabaaa
adaaaaaaabeaaaaamnmmimeadcaaaaajdcaabaaaadaaaaaaogakbaaaadaaaaaa
kgakbaaaacaaaaaaagaabaaaadaaaaaaebaaaaafdcaabaaaadaaaaaaegaabaaa
adaaaaaadgaaaaaimcaabaaaadaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaeb
aaaaaaebdgaaaaafecaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabccaaaaah
bcaabaaaaeaaaaaaabeaaaaaabaaaaaackaabaaaacaaaaaaadaaaeadakaabaaa
aeaaaaaaclaaaaafccaabaaaaeaaaaaackaabaaaacaaaaaadgaaaaafmcaabaaa
aeaaaaaakgaobaaaadaaaaaadgaaaaafbcaabaaaafaaaaaaabeaaaaapppppppp
daaaaaabccaaaaahccaabaaaafaaaaaaabeaaaaaabaaaaaaakaabaaaafaaaaaa
adaaaeadbkaabaaaafaaaaaaclaaaaafbcaabaaaaeaaaaaaakaabaaaafaaaaaa
aaaaaaahgcaabaaaafaaaaaaagabbaaaadaaaaaaagabbaaaaeaaaaaaapaaaaak
bcaabaaaaeaaaaaajgafbaaaafaaaaaaaceaaaaaaaaapkedaaaamiecaaaaaaaa
aaaaaaaaenaaaaagbcaabaaaaeaaaaaaaanaaaaaakaabaaaaeaaaaaaapaaaaak
ccaabaaaafaaaaaajgafbaaaafaaaaaaaceaaaaaaaaahkedaaaaeaecaaaaaaaa
aaaaaaaaenaaaaagaanaaaaaccaabaaaafaaaaaabkaabaaaafaaaaaabkaaaaaf
bcaabaaaaeaaaaaaakaabaaaaeaaaaaabkaaaaafccaabaaaafaaaaaabkaabaaa
afaaaaaadeaaaaahbcaabaaaagaaaaaaakaabaaaaeaaaaaabkaabaaaafaaaaaa
dbaaaaahgcaabaaaafaaaaaaagaabaaaagaaaaaakgalbaaaaeaaaaaadhaaaaaj
ecaabaaaagaaaaaackaabaaaafaaaaaaakaabaaaagaaaaaadkaabaaaaeaaaaaa
dgaaaaafccaabaaaagaaaaaackaabaaaaeaaaaaadhaaaaajmcaabaaaaeaaaaaa
fgafbaaaafaaaaaaagaebaaaagaaaaaafgajbaaaagaaaaaaboaaaaahbcaabaaa
afaaaaaaakaabaaaafaaaaaaabeaaaaaabaaaaaabgaaaaabdgaaaaafmcaabaaa
adaaaaaakgaobaaaaeaaaaaaboaaaaahecaabaaaacaaaaaackaabaaaacaaaaaa
abeaaaaaabaaaaaabgaaaaabaaaaaaaiecaabaaaacaaaaaackaabaiaebaaaaaa
adaaaaaadkaabaaaadaaaaaaaaaaaaahecaabaaaacaaaaaackaabaaaacaaaaaa
abeaaaaaaknhkdlmdiaaaaahecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaa
poeebamdbjaaaaafecaabaaaacaaaaaackaabaaaacaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaacaaaaaaabeaaaaamnmmmmdnckaabaaaabaaaaaabfaaaaab
boaaaaahicaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaaabaaaaaabgaaaaab
diaaaaaihccabaaaaaaaaaaakgakbaaaabaaaaaaegiccaaaaaaaaaaaabaaaaaa
dgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadgaaaaafbccabaaaabaaaaaa
abeaaaaahcpjhpdpdoaaaaab"
}
SubProgram "gles3 " {
"!!GLES3"
}
}
 }
}
Fallback "Diffuse"
}