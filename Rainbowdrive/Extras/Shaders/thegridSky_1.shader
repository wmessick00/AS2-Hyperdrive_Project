// Compiled shader for all platforms, uncompressed size: 41.2KB

Shader "Skyscreen/TheGridSky" {
Properties {
 iPrimaryColor ("PrimaryColor", Color) = (1,1,1,1)
 iFloorHeight ("FloorHeight", Float) = -11
 iIntensity ("Intensity", Float) = 0.5
 iIntensityTime ("IntensityTime", Float) = 0.5
 iCeilingHeight ("CeilingHeight", Float) = 111
}
SubShader { 


 // Stats for Vertex shader:
 //       d3d11 : 8 math
 //        d3d9 : 10 math
 //      opengl : 10 math
 // Stats for Fragment shader:
 //       d3d11 : 106 math, 4 branch
 //        d3d9 : 291 math, 11 branch
 //      opengl : 800 math
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
uniform highp float iCeilingHeight;
uniform highp float iIntensity;
uniform highp float iIntensityTime;
highp vec4 xlat_mutableiPrimaryColor;
in highp vec4 xlv_TEXCOORD1;
void main ()
{
  xlat_mutableiPrimaryColor = iPrimaryColor;
  int i_1;
  highp float layerDir_2;
  highp float startHeight_3;
  highp float inten_4;
  highp vec3 rd_5;
  highp vec3 ro_6;
  ro_6 = _WorldSpaceCameraPos;
  highp vec3 tmpvar_7;
  tmpvar_7 = normalize((xlv_TEXCOORD1.xyz - _WorldSpaceCameraPos));
  rd_5 = tmpvar_7;
  inten_4 = pow ((1.0 - abs(tmpvar_7.y)), (11.0 + ((1.0 - iIntensity) * 30.0)));
  highp float r_8;
  if ((abs(tmpvar_7.y) > (1e-08 * abs(tmpvar_7.x)))) {
    highp float y_over_x_9;
    y_over_x_9 = (tmpvar_7.x / tmpvar_7.y);
    highp float s_10;
    highp float x_11;
    x_11 = (y_over_x_9 * inversesqrt(((y_over_x_9 * y_over_x_9) + 1.0)));
    s_10 = (sign(x_11) * (1.5708 - (sqrt((1.0 - abs(x_11))) * (1.5708 + (abs(x_11) * (-0.214602 + (abs(x_11) * (0.0865667 + (abs(x_11) * -0.0310296)))))))));
    r_8 = s_10;
    if ((tmpvar_7.y < 0.0)) {
      if ((tmpvar_7.x >= 0.0)) {
        r_8 = (s_10 + 3.14159);
      } else {
        r_8 = (r_8 - 3.14159);
      };
    };
  } else {
    r_8 = (sign(tmpvar_7.x) * 1.5708);
  };
  highp float tmpvar_12;
  tmpvar_12 = (iIntensityTime * 1.7);
  highp float tmpvar_13;
  tmpvar_13 = (inten_4 + ((pow ((((fract((sin((floor(((r_8 * 4.0) + tmpvar_12)) * 11.11)) * 547.89)) * (-0.2 + (iIntensity * 0.7))) + (fract((sin((floor(((r_8 * 8.0) - tmpvar_12)) * 11.11)) * 547.89)) * 0.25)) + (fract((sin((floor(((r_8 * 16.0) + tmpvar_12)) * 11.11)) * 547.89)) * 0.125)), 5.0) * (1.0/(((tmpvar_7.y * tmpvar_7.y) * (1.0 - iIntensity))))) * 0.1));
  inten_4 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = (iFloorHeight - 5000.0);
  highp vec3 tmpvar_15;
  tmpvar_15.xz = vec2(0.0, 0.0);
  tmpvar_15.y = tmpvar_14;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_WorldSpaceCameraPos - tmpvar_15);
  highp vec3 tmpvar_17;
  tmpvar_17.x = dot (vec3(0.0, -1.0, 0.0), tmpvar_16);
  tmpvar_17.y = dot (((tmpvar_16.yzx * vec3(0.0, 1.0, 0.0)) - (tmpvar_16.zxy * vec3(0.0, 0.0, 1.0))), tmpvar_7);
  tmpvar_17.z = dot (((vec3(0.0, 1.0, 0.0) * tmpvar_16.zxy) - (vec3(1.0, 0.0, 0.0) * tmpvar_16.yzx)), tmpvar_7);
  highp float tmpvar_18;
  tmpvar_18 = float((0.0 >= (tmpvar_17 / tmpvar_7.y).x));
  startHeight_3 = (tmpvar_14 + (tmpvar_18 * (iCeilingHeight - tmpvar_14)));
  layerDir_2 = (-1.0 + (tmpvar_18 * 2.0));
  i_1 = 0;
  for (int i_1 = 0; i_1 < 5; ) {
    highp float tmpvar_19;
    tmpvar_19 = float(i_1);
    highp vec3 tmpvar_20;
    tmpvar_20.xz = vec2(0.0, 0.0);
    tmpvar_20.y = (startHeight_3 + ((tmpvar_19 * 25000.0) * layerDir_2));
    highp vec3 tmpvar_21;
    highp vec3 tmpvar_22;
    tmpvar_22 = (ro_6 - tmpvar_20);
    highp vec3 tmpvar_23;
    tmpvar_23.x = dot (vec3(0.0, -1.0, 0.0), tmpvar_22);
    tmpvar_23.y = dot (((tmpvar_22.yzx * vec3(0.0, 1.0, 0.0)) - (tmpvar_22.zxy * vec3(0.0, 0.0, 1.0))), rd_5);
    tmpvar_23.z = dot (((vec3(0.0, 1.0, 0.0) * tmpvar_22.zxy) - (vec3(1.0, 0.0, 0.0) * tmpvar_22.yzx)), rd_5);
    tmpvar_21 = (tmpvar_23 / rd_5.y);
    if ((tmpvar_21.x > 0.0)) {
      int j_24;
      highp float md2_25;
      highp float md_26;
      highp vec2 mg_27;
      highp vec2 n_28;
      highp vec2 tmpvar_29;
      tmpvar_29 = floor(((tmpvar_21.yz * (0.0001 + (0.0003 * tmpvar_19))) + (((180.0 + iIntensityTime) * (tmpvar_19 - 3.0)) * 4.4)));
      n_28 = tmpvar_29;
      md_26 = 8.0;
      md2_25 = 8.0;
      j_24 = 0;
      while (true) {
        int i_30;
        if ((j_24 > 1)) {
          break;
        };
        i_30 = -1;
        while (true) {
          if ((i_30 > 1)) {
            break;
          };
          highp vec2 tmpvar_31;
          tmpvar_31.x = float(i_30);
          tmpvar_31.y = float(j_24);
          highp vec2 p_32;
          p_32 = (n_28 + tmpvar_31);
          highp vec2 tmpvar_33;
          tmpvar_33.x = sin(((p_32.x * 500.0) + (p_32.y * 100.0)));
          tmpvar_33.y = cos(((p_32.x * 250.0) + (p_32.y * 48.0)));
          highp vec2 tmpvar_34;
          tmpvar_34 = fract(tmpvar_33);
          highp float tmpvar_35;
          tmpvar_35 = max (abs(tmpvar_34.x), abs(tmpvar_34.y));
          if ((tmpvar_35 < md_26)) {
            md2_25 = md_26;
            md_26 = tmpvar_35;
            mg_27 = tmpvar_31;
          } else {
            if ((tmpvar_35 < md2_25)) {
              md2_25 = tmpvar_35;
            };
          };
          i_30 = (i_30 + 1);
        };
        j_24 = (j_24 + 1);
      };
      highp vec3 tmpvar_36;
      tmpvar_36.xy = (tmpvar_29 + mg_27);
      tmpvar_36.z = (md2_25 - md_26);
      inten_4 = (inten_4 + (exp((-100.0 * (tmpvar_36.z - 0.02))) * 0.1));
    };
    i_1 = (i_1 + 1);
  };
  highp float tmpvar_37;
  tmpvar_37 = max (inten_4, tmpvar_13);
  inten_4 = tmpvar_37;
  xlat_mutableiPrimaryColor.xyz = ((tmpvar_18 * (vec3(1.0, 1.0, 1.0) - iPrimaryColor.xyz)) + ((1.0 - tmpvar_18) * iPrimaryColor.xyz));
  highp vec4 tmpvar_38;
  tmpvar_38.w = 0.0;
  tmpvar_38.xyz = (xlat_mutableiPrimaryColor.xyz * tmpvar_37);
  _glesFragData[0] = tmpvar_38;
  gl_FragDepth = 0.9999;
}



#endif"
}
}
Program "fp" {
SubProgram "opengl " {
// Stats: 800 math
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [iPrimaryColor]
Float 2 [iFloorHeight]
Float 3 [iCeilingHeight]
Float 4 [iIntensity]
Float 5 [iIntensityTime]
"3.0-!!ARBfp1.0
PARAM c[19] = { program.local[0..5],
		{ 0, 0.99989998, 5000, -1 },
		{ 1, 2, 100000, 0 },
		{ 2.718282, 0.0013, 180, 4.4000001 },
		{ 500, 100, 250, 48 },
		{ -1, 1, 8, 0.02 },
		{ -100, 0.1, 75000, 0.001 },
		{ 50000, 0.00070000003, 25000, 0.00040000002 },
		{ -8.8000002, 0, 9.9999997e-005, -13.200001 },
		{ -0.01348047, 0.05747731, 0.1212391, 0.1956359 },
		{ 0.33299461, 0.99999559, 1.570796, 3.141593 },
		{ 16, 1.7, 11.11, 547.89001 },
		{ 0.125, 4, 0.69999999, -0.2 },
		{ 0.25, 5, 30, 11 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
ADD R1.xyz, fragment.texcoord[1], -c[0];
DP3 R0.x, R1, R1;
MOV R0.w, c[6].z;
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
ADD R2.x, -R0.w, c[2];
RCP R4.w, R0.y;
MOV R1.y, R2.x;
MOV R1.xz, c[6].x;
ADD R1.xyz, -R1, c[0];
DP3 R0.w, R1, c[6].xwxw;
MUL R0.w, R0, R4;
SGE R1.w, c[6].x, R0;
ADD R0.w, -R2.x, c[3].x;
MAD R3.w, R1, R0, R2.x;
MUL R1.x, R1.w, c[7].y;
ADD R2.w, R1.x, c[6];
MOV R0.w, c[8].z;
ADD R5.x, R0.w, c[5];
MAD R1.y, R2.w, c[12].x, R3.w;
MOV R1.xz, c[6].x;
ADD R1.xyz, -R1, c[0];
MUL R2.xyz, -R1.zxyw, c[7].wwxw;
MAD R3.xyz, R1.yzxw, c[7].wxww, R2;
DP3 R3.y, R0, R3;
MUL R2.xyz, -R1.yzxw, c[7].xwww;
MAD R2.xyz, R1.zxyw, c[7].wxww, R2;
DP3 R3.z, R0, R2;
DP3 R3.x, R1, c[6].xwxw;
MUL R1.xyz, R4.w, R3;
MUL R0.w, R5.x, c[8];
MAD R2.xy, R1.yzzw, c[12].y, -R0.w;
FLR R2.xy, R2;
ADD R3.xy, R2, c[6].wxzw;
MUL R1.y, R3, c[9].w;
MUL R1.z, R3.y, c[9].y;
MAD R1.y, R3.x, c[9].z, R1;
MAD R1.z, R3.x, c[9].x, R1;
SLT R2.z, c[6].x, R1.x;
COS R3.y, R1.y;
SIN R3.x, R1.z;
FRC R3.xy, R3;
ABS R1.y, R3;
ABS R1.z, R3.x;
MAX R3.z, R1, R1.y;
SLT R4.y, R3.z, c[10].z;
MUL R1.y, R2.z, R4;
CMP R1.z, -R1.y, R3, c[10];
MUL R3.y, R2, c[9];
MOV R1.y, c[7].x;
ABS R3.x, R4.y;
CMP R4.x, -R3, c[6], R1.y;
MUL R3.x, R2.y, c[9].w;
MAD R4.z, R2.x, c[9].x, R3.y;
MAD R3.x, R2, c[9].z, R3;
COS R3.y, R3.x;
SIN R3.x, R4.z;
FRC R3.xy, R3;
MUL R4.z, R2, R4.x;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R4.x, R3, R3.y;
SLT R5.y, R4.x, R1.z;
MUL R3.x, R4.y, R4.z;
CMP R3.x, -R3, R3.z, c[10].z;
MUL R3.z, R2, R5.y;
CMP R4.y, -R3.z, R1.z, R3.x;
ABS R3.y, R5;
CMP R3.x, -R3.y, c[6], R1.y;
MUL R5.y, R2.z, R3.x;
ADD R3.xy, R2, c[7].xwzw;
SLT R4.z, R4.x, R4.y;
MUL R4.z, R5.y, R4;
CMP R3.z, -R3, R4.x, R1;
MUL R5.y, R3, c[9].w;
MUL R5.z, R3.y, c[9].y;
MAD R3.y, R3.x, c[9].z, R5;
MAD R3.x, R3, c[9], R5.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R1.z, R3.y;
ABS R3.x, R3;
MAX R1.z, R3.x, R1;
SLT R5.y, R1.z, R3.z;
CMP R3.x, -R4.z, R4, R4.y;
MUL R4.x, R2.z, R5.y;
CMP R4.y, -R4.x, R3.z, R3.x;
ABS R3.y, R5;
CMP R3.x, -R3.y, c[6], R1.y;
MUL R5.y, R2.z, R3.x;
ADD R3.xy, R2, c[10];
SLT R4.z, R1, R4.y;
MUL R4.z, R5.y, R4;
CMP R4.x, -R4, R1.z, R3.z;
MUL R5.y, R3, c[9].w;
MUL R5.z, R3.y, c[9].y;
MAD R3.y, R3.x, c[9].z, R5;
MAD R3.x, R3, c[9], R5.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R3.z, R3.x, R3.y;
SLT R5.y, R3.z, R4.x;
CMP R3.x, -R4.z, R1.z, R4.y;
MUL R1.z, R2, R5.y;
CMP R4.y, -R1.z, R4.x, R3.x;
ABS R3.y, R5;
CMP R3.x, -R3.y, c[6], R1.y;
MUL R5.y, R2.z, R3.x;
ADD R3.xy, R2, c[7].wxzw;
SLT R4.z, R3, R4.y;
MUL R4.z, R5.y, R4;
CMP R1.z, -R1, R3, R4.x;
ADD R2.xy, R2, c[7].x;
MUL R5.y, R3, c[9].w;
MUL R5.z, R3.y, c[9].y;
MAD R3.y, R3.x, c[9].z, R5;
MAD R3.x, R3, c[9], R5.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R3.y, R3;
ABS R3.x, R3;
MAX R3.x, R3, R3.y;
SLT R5.y, R3.x, R1.z;
CMP R3.y, -R4.z, R3.z, R4;
MUL R3.z, R2, R5.y;
CMP R3.y, -R3.z, R1.z, R3;
ABS R4.x, R5.y;
CMP R4.y, -R4.x, c[6].x, R1;
CMP R1.z, -R3, R3.x, R1;
SLT R4.x, R3, R3.y;
MUL R4.y, R2.z, R4;
MUL R4.x, R4.y, R4;
MUL R4.y, R2, c[9].w;
MUL R4.z, R2.y, c[9].y;
MAD R2.y, R2.x, c[9].z, R4;
MAD R2.x, R2, c[9], R4.z;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R5.y, R2.x, R2;
SLT R3.z, R5.y, R1;
ABS R2.y, R3.z;
CMP R2.y, -R2, c[6].x, R1;
CMP R2.x, -R4, R3, R3.y;
MUL R5.z, R2, R3;
CMP R3.y, -R5.z, R1.z, R2.x;
SLT R2.x, R5.y, R3.y;
MUL R2.y, R2.z, R2;
MUL R3.x, R2.y, R2;
CMP R5.w, -R3.x, R5.y, R3.y;
CMP R1.z, -R5, R5.y, R1;
MAD R2.y, R2.w, c[12].z, R3.w;
MOV R2.xz, c[6].x;
ADD R2.xyz, -R2, c[0];
MUL R3.xyz, -R2.zxyw, c[7].wwxw;
MAD R3.xyz, R2.yzxw, c[7].wxww, R3;
DP3 R3.y, R0, R3;
MUL R4.xyz, -R2.yzxw, c[7].xwww;
MAD R4.xyz, R2.zxyw, c[7].wxww, R4;
DP3 R3.z, R0, R4;
DP3 R3.x, R2, c[6].xwxw;
MUL R2.xyz, R4.w, R3;
MUL R4.x, R5, c[13];
MAD R3.xy, R2.yzzw, c[12].w, R4.x;
FLR R3.xy, R3;
ADD R4.xy, R3, c[6].wxzw;
ADD R1.z, R5.w, -R1;
ADD R2.z, R1, -c[10].w;
MUL R1.z, R4.y, c[9].w;
MUL R2.y, R4, c[9];
MAD R1.z, R4.x, c[9], R1;
MAD R2.y, R4.x, c[9].x, R2;
SLT R3.z, c[6].x, R2.x;
COS R4.y, R1.z;
SIN R4.x, R2.y;
FRC R4.xy, R4;
ABS R1.z, R4.y;
ABS R2.y, R4.x;
MAX R4.z, R2.y, R1;
SLT R5.y, R4.z, c[10].z;
MUL R2.y, R3.z, R5;
MUL R4.y, R3, c[9];
MUL R2.z, R2, c[11].x;
POW R1.z, c[8].x, R2.z;
ABS R2.z, R5.y;
MUL R4.x, R3.y, c[9].w;
CMP R2.y, -R2, R4.z, c[10].z;
CMP R2.z, -R2, c[6].x, R1.y;
MAD R5.z, R3.x, c[9].x, R4.y;
MAD R4.x, R3, c[9].z, R4;
COS R4.y, R4.x;
SIN R4.x, R5.z;
FRC R4.xy, R4;
MUL R5.z, R3, R2;
ABS R2.z, R4.y;
ABS R4.x, R4;
MAX R2.z, R4.x, R2;
SLT R5.w, R2.z, R2.y;
MUL R4.x, R5.y, R5.z;
CMP R4.x, -R4, R4.z, c[10].z;
MUL R4.z, R3, R5.w;
CMP R5.y, -R4.z, R2, R4.x;
ABS R4.y, R5.w;
CMP R4.x, -R4.y, c[6], R1.y;
MUL R5.w, R3.z, R4.x;
ADD R4.xy, R3, c[7].xwzw;
SLT R5.z, R2, R5.y;
MUL R5.z, R5.w, R5;
CMP R2.y, -R4.z, R2.z, R2;
MUL R5.w, R4.y, c[9];
MUL R6.x, R4.y, c[9].y;
MAD R4.y, R4.x, c[9].z, R5.w;
MAD R4.x, R4, c[9], R6;
MUL R5.x, R5, c[13].w;
COS R4.y, R4.y;
SIN R4.x, R4.x;
FRC R4.xy, R4;
ABS R4.y, R4;
ABS R4.x, R4;
MAX R4.z, R4.x, R4.y;
SLT R5.w, R4.z, R2.y;
CMP R4.x, -R5.z, R2.z, R5.y;
MUL R2.z, R3, R5.w;
CMP R5.y, -R2.z, R2, R4.x;
ABS R4.y, R5.w;
CMP R4.x, -R4.y, c[6], R1.y;
MUL R5.w, R3.z, R4.x;
ADD R4.xy, R3, c[10];
SLT R5.z, R4, R5.y;
MUL R5.z, R5.w, R5;
CMP R2.y, -R2.z, R4.z, R2;
MUL R5.w, R4.y, c[9];
MUL R6.x, R4.y, c[9].y;
MAD R4.y, R4.x, c[9].z, R5.w;
MAD R4.x, R4, c[9], R6;
COS R4.y, R4.y;
SIN R4.x, R4.x;
FRC R4.xy, R4;
ABS R2.z, R4.y;
ABS R4.x, R4;
MAX R2.z, R4.x, R2;
SLT R5.w, R2.z, R2.y;
CMP R4.x, -R5.z, R4.z, R5.y;
MUL R5.z, R3, R5.w;
CMP R4.z, -R5, R2.y, R4.x;
ABS R4.y, R5.w;
CMP R4.x, -R4.y, c[6], R1.y;
MUL R5.w, R3.z, R4.x;
ADD R4.xy, R3, c[7].wxzw;
SLT R5.y, R2.z, R4.z;
MUL R5.y, R5.w, R5;
ADD R3.xy, R3, c[7].x;
CMP R2.y, -R5.z, R2.z, R2;
MUL R5.w, R4.y, c[9];
MUL R6.x, R4.y, c[9].y;
MAD R4.y, R4.x, c[9].z, R5.w;
MAD R4.x, R4, c[9], R6;
COS R4.y, R4.y;
SIN R4.x, R4.x;
FRC R4.xy, R4;
ABS R4.y, R4;
ABS R4.x, R4;
MAX R4.x, R4, R4.y;
SLT R5.z, R4.x, R2.y;
CMP R4.y, -R5, R2.z, R4.z;
MUL R2.z, R3, R5;
ABS R4.z, R5;
CMP R4.y, -R2.z, R2, R4;
CMP R5.y, -R4.z, c[6].x, R1;
CMP R2.y, -R2.z, R4.x, R2;
SLT R4.z, R4.x, R4.y;
MUL R5.y, R3.z, R5;
MUL R4.z, R5.y, R4;
MUL R5.y, R3, c[9].w;
MUL R5.z, R3.y, c[9].y;
MAD R3.y, R3.x, c[9].z, R5;
MAD R3.x, R3, c[9], R5.z;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R2.z, R3.y;
ABS R3.x, R3;
MAX R2.z, R3.x, R2;
SLT R5.y, R2.z, R2;
ABS R3.y, R5;
CMP R3.y, -R3, c[6].x, R1;
CMP R3.x, -R4.z, R4, R4.y;
MUL R5.y, R3.z, R5;
CMP R4.x, -R5.y, R2.y, R3;
SLT R3.x, R2.z, R4;
MUL R3.y, R3.z, R3;
MUL R4.y, R3, R3.x;
CMP R5.z, -R4.y, R2, R4.x;
CMP R2.y, -R5, R2.z, R2;
ADD R2.y, R5.z, -R2;
MOV R3.y, R3.w;
MOV R3.xz, c[6].x;
ADD R3.xyz, -R3, c[0];
MUL R4.xyz, -R3.zxyw, c[7].wwxw;
MAD R4.xyz, R3.yzxw, c[7].wxww, R4;
DP3 R4.y, R0, R4;
MUL R6.xyz, -R3.yzxw, c[7].xwww;
MAD R6.xyz, R3.zxyw, c[7].wxww, R6;
DP3 R4.z, R0, R6;
DP3 R4.x, R3, c[6].xwxw;
MUL R3.xyz, R4.w, R4;
MAD R4.xy, R3.yzzw, c[13].z, R5.x;
FLR R4.xy, R4;
ADD R5.xy, R4, c[6].wxzw;
ADD R3.y, R2, -c[10].w;
MUL R2.y, R5, c[9].w;
MUL R2.z, R5.y, c[9].y;
MAD R2.y, R5.x, c[9].z, R2;
MAD R2.z, R5.x, c[9].x, R2;
COS R5.y, R2.y;
SIN R5.x, R2.z;
FRC R5.xy, R5;
ABS R2.y, R5;
ABS R2.z, R5.x;
MAX R4.z, R2, R2.y;
SLT R5.z, R4, c[10];
MUL R5.y, R4, c[9];
MUL R3.y, R3, c[11].x;
POW R2.y, c[8].x, R3.y;
SLT R3.y, c[6].x, R3.x;
MUL R2.z, R3.y, R5;
ABS R3.z, R5;
MUL R5.x, R4.y, c[9].w;
CMP R2.z, -R2, R4, c[10];
CMP R3.z, -R3, c[6].x, R1.y;
MAD R5.w, R4.x, c[9].x, R5.y;
MAD R5.x, R4, c[9].z, R5;
COS R5.y, R5.x;
SIN R5.x, R5.w;
FRC R5.xy, R5;
MUL R5.w, R3.y, R3.z;
ABS R3.z, R5.y;
ABS R5.x, R5;
MAX R3.z, R5.x, R3;
SLT R6.x, R3.z, R2.z;
MUL R5.x, R5.z, R5.w;
MUL R5.w, R3.y, R6.x;
CMP R4.z, -R5.x, R4, c[10];
CMP R4.z, -R5.w, R2, R4;
ABS R5.y, R6.x;
CMP R5.x, -R5.y, c[6], R1.y;
MUL R6.x, R3.y, R5;
ADD R5.xy, R4, c[7].xwzw;
SLT R5.z, R3, R4;
MUL R5.z, R6.x, R5;
CMP R2.z, -R5.w, R3, R2;
CMP R3.z, -R5, R3, R4;
MUL R6.x, R5.y, c[9].w;
MUL R6.y, R5, c[9];
MAD R5.y, R5.x, c[9].z, R6.x;
MAD R5.x, R5, c[9], R6.y;
COS R5.y, R5.y;
SIN R5.x, R5.x;
FRC R5.xy, R5;
ABS R5.y, R5;
ABS R5.x, R5;
MAX R5.w, R5.x, R5.y;
SLT R5.x, R5.w, R2.z;
MUL R5.z, R3.y, R5.x;
CMP R3.z, -R5, R2, R3;
ABS R4.z, R5.x;
CMP R5.x, -R4.z, c[6], R1.y;
MUL R6.x, R3.y, R5;
ADD R5.xy, R4, c[10];
SLT R4.z, R5.w, R3;
MUL R4.z, R6.x, R4;
CMP R2.z, -R5, R5.w, R2;
MUL R6.x, R5.y, c[9].w;
MUL R6.y, R5, c[9];
MAD R5.y, R5.x, c[9].z, R6.x;
MAD R5.x, R5, c[9], R6.y;
CMP R3.z, -R4, R5.w, R3;
COS R5.y, R5.y;
SIN R5.x, R5.x;
FRC R5.xy, R5;
ABS R5.y, R5;
ABS R5.x, R5;
MAX R5.z, R5.x, R5.y;
SLT R5.x, R5.z, R2.z;
MUL R5.w, R3.y, R5.x;
CMP R3.z, -R5.w, R2, R3;
ABS R4.z, R5.x;
CMP R5.x, -R4.z, c[6], R1.y;
MUL R6.x, R3.y, R5;
ADD R5.xy, R4, c[7].wxzw;
SLT R4.z, R5, R3;
MUL R4.z, R6.x, R4;
CMP R2.z, -R5.w, R5, R2;
ADD R4.xy, R4, c[7].x;
CMP R3.z, -R4, R5, R3;
MUL R6.x, R5.y, c[9].w;
MUL R6.y, R5, c[9];
MAD R5.y, R5.x, c[9].z, R6.x;
MAD R5.x, R5, c[9], R6.y;
COS R5.y, R5.y;
SIN R5.x, R5.x;
FRC R5.xy, R5;
ABS R5.y, R5;
ABS R5.x, R5;
MAX R5.x, R5, R5.y;
SLT R5.y, R5.x, R2.z;
ABS R5.z, R5.y;
MUL R4.z, R3.y, R5.y;
CMP R5.y, -R4.z, R2.z, R3.z;
CMP R4.z, -R4, R5.x, R2;
CMP R5.z, -R5, c[6].x, R1.y;
ABS R2.z, R0.y;
SLT R3.z, R5.x, R5.y;
MUL R5.z, R3.y, R5;
MUL R3.z, R5, R3;
CMP R3.z, -R3, R5.x, R5.y;
ABS R5.x, R0;
MUL R5.y, R4, c[9].w;
MUL R5.z, R4.y, c[9].y;
MAD R4.y, R4.x, c[9].z, R5;
MAD R4.x, R4, c[9], R5.z;
COS R4.y, R4.y;
SIN R4.x, R4.x;
FRC R4.xy, R4;
ABS R5.y, R4.x;
MAX R4.x, R5, R2.z;
ABS R4.y, R4;
MAX R4.y, R5, R4;
SLT R6.x, R4.y, R4.z;
MIN R5.y, R5.x, R2.z;
ADD R5.x, R5, -R2.z;
RCP R4.x, R4.x;
MUL R5.z, R5.y, R4.x;
MUL R5.w, R5.z, R5.z;
MUL R4.x, R3.y, R6;
MAD R5.y, R5.w, c[14].x, c[14];
MAD R6.y, R5, R5.w, -c[14].z;
CMP R3.z, -R4.x, R4, R3;
MAD R6.y, R6, R5.w, c[14].w;
ABS R6.z, R6.x;
MAD R6.x, R6.y, R5.w, -c[15];
CMP R6.y, -R6.z, c[6].x, R1;
MAD R5.w, R6.x, R5, c[15].y;
MUL R3.y, R3, R6;
SLT R5.y, R4, R3.z;
MUL R5.z, R5.w, R5;
MUL R5.y, R3, R5;
ADD R3.y, -R5.z, c[15].z;
CMP R5.x, -R5, R3.y, R5.z;
CMP R5.z, -R5.y, R4.y, R3;
ADD R3.z, -R5.x, c[15].w;
CMP R3.z, R0.y, R3, R5.x;
CMP R5.y, R0.x, -R3.z, R3.z;
CMP R3.z, -R4.x, R4.y, R4;
ADD R3.z, R5, -R3;
MOV R3.y, c[16];
MUL R5.x, R3.y, c[5];
MAD R3.y, R5, c[16].x, R5.x;
MAD R4.y, R5, c[17], R5.x;
FLR R3.y, R3;
FLR R4.y, R4;
MUL R4.y, R4, c[16].z;
SIN R4.y, R4.y;
MUL R4.y, R4, c[16].w;
FRC R4.z, R4.y;
MOV R4.y, c[4].x;
ADD R4.x, R3.z, -c[10].w;
MUL R3.y, R3, c[16].z;
SIN R3.z, R3.y;
MUL R3.y, R4.x, c[11].x;
MAD R4.x, R5.y, c[10].z, -R5;
MUL R3.z, R3, c[16].w;
FLR R4.x, R4;
MUL R4.x, R4, c[16].z;
SIN R4.x, R4.x;
MUL R4.x, R4, c[16].w;
FRC R4.x, R4;
MAD R4.y, R4, c[17].z, c[17].w;
MUL R4.x, R4, c[18];
MAD R4.x, R4.z, R4.y, R4;
FRC R3.z, R3;
MAD R3.z, R3, c[17].x, R4.x;
POW R5.y, R3.z, c[18].y;
MAD R4.y, R2.w, c[11].z, R3.w;
ADD R3.z, R1.y, -c[4].x;
MUL R4.x, R0.y, R0.y;
MUL R5.x, R4, R3.z;
RCP R5.x, R5.x;
MOV R4.xz, c[6].x;
ADD R4.xyz, -R4, c[0];
MUL R5.w, R5.y, R5.x;
MUL R6.xyz, -R4.zxyw, c[7].wwxw;
MAD R6.xyz, R4.yzxw, c[7].wxww, R6;
DP3 R6.y, R0, R6;
MUL R5.xyz, -R4.yzxw, c[7].xwww;
MAD R5.xyz, R4.zxyw, c[7].wxww, R5;
DP3 R6.z, R0, R5;
DP3 R6.x, R4, c[6].xwxw;
MUL R4.xyz, R4.w, R6;
MUL R5.xy, R4.yzzw, c[11].w;
FLR R5.xy, R5;
POW R3.y, c[8].x, R3.y;
MAD R3.z, R3, c[18], c[18].w;
ADD R2.z, -R2, c[7].x;
POW R2.z, R2.z, R3.z;
MAD R5.z, R5.w, c[11].y, R2;
MAD R2.z, R3.y, c[11].y, R5;
CMP R2.z, -R3.x, R2, R5;
ADD R3.xy, R5, c[6].wxzw;
MAD R2.y, R2, c[11], R2.z;
CMP R2.z, -R2.x, R2.y, R2;
MUL R3.z, R3.y, c[9].w;
MUL R4.y, R3, c[9];
MAD R3.y, R3.x, c[9].z, R3.z;
MAD R3.x, R3, c[9], R4.y;
COS R3.y, R3.y;
SIN R3.x, R3.x;
FRC R3.xy, R3;
ABS R2.y, R3.x;
MAD R3.x, R1.z, c[11].y, R2.z;
ABS R2.x, R3.y;
MAX R3.z, R2.y, R2.x;
SLT R4.z, R3, c[10];
SLT R1.z, c[6].x, R4.x;
MUL R2.y, R1.z, R4.z;
CMP R3.y, -R2, R3.z, c[10].z;
ABS R2.x, R4.z;
CMP R4.y, -R2.x, c[6].x, R1;
MUL R2.y, R5, c[9];
MUL R2.x, R5.y, c[9].w;
CMP R1.x, -R1, R3, R2.z;
MAD R5.w, R5.x, c[9].x, R2.y;
MAD R2.x, R5, c[9].z, R2;
COS R2.y, R2.x;
SIN R2.x, R5.w;
FRC R2.xy, R2;
MUL R5.w, R1.z, R4.y;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R4.y, R2.x, R2;
SLT R6.x, R4.y, R3.y;
MUL R2.x, R4.z, R5.w;
CMP R2.x, -R2, R3.z, c[10].z;
MUL R3.z, R1, R6.x;
CMP R4.z, -R3, R3.y, R2.x;
ABS R2.y, R6.x;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R6.x, R1.z, R2;
ADD R2.xy, R5, c[7].xwzw;
SLT R5.w, R4.y, R4.z;
MUL R5.w, R6.x, R5;
CMP R3.y, -R3.z, R4, R3;
MUL R6.x, R2.y, c[9].w;
MUL R6.y, R2, c[9];
MAD R2.y, R2.x, c[9].z, R6.x;
MAD R2.x, R2, c[9], R6.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R3.z, R2.x, R2.y;
SLT R6.x, R3.z, R3.y;
CMP R2.x, -R5.w, R4.y, R4.z;
MUL R4.y, R1.z, R6.x;
CMP R4.z, -R4.y, R3.y, R2.x;
ABS R2.y, R6.x;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R6.x, R1.z, R2;
ADD R2.xy, R5, c[10];
SLT R5.w, R3.z, R4.z;
MUL R5.w, R6.x, R5;
CMP R3.y, -R4, R3.z, R3;
MUL R6.x, R2.y, c[9].w;
MUL R6.y, R2, c[9];
MAD R2.y, R2.x, c[9].z, R6.x;
MAD R2.x, R2, c[9], R6.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R4.y, R2.x, R2;
SLT R6.x, R4.y, R3.y;
CMP R2.x, -R5.w, R3.z, R4.z;
MUL R3.z, R1, R6.x;
CMP R4.z, -R3, R3.y, R2.x;
ABS R2.y, R6.x;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R6.x, R1.z, R2;
ADD R2.xy, R5, c[7].wxzw;
SLT R5.w, R4.y, R4.z;
MUL R5.w, R6.x, R5;
CMP R3.z, -R3, R4.y, R3.y;
MUL R6.x, R2.y, c[9].w;
MUL R6.y, R2, c[9];
MAD R2.y, R2.x, c[9].z, R6.x;
MAD R2.x, R2, c[9], R6.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R3.y, R2.x, R2;
SLT R6.x, R3.y, R3.z;
CMP R2.x, -R5.w, R4.y, R4.z;
MUL R4.y, R1.z, R6.x;
CMP R5.w, -R4.y, R3.z, R2.x;
ABS R2.y, R6.x;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R6.x, R1.z, R2;
ADD R2.xy, R5, c[7].x;
SLT R4.z, R3.y, R5.w;
MUL R5.x, R6, R4.z;
CMP R4.y, -R4, R3, R3.z;
MUL R4.z, R2.y, c[9].w;
MUL R5.y, R2, c[9];
MAD R2.y, R2.x, c[9].z, R4.z;
MAD R2.x, R2, c[9], R5.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R4.z, R2.x, R2.y;
SLT R2.y, R4.z, R4;
CMP R2.x, -R5, R3.y, R5.w;
MUL R5.x, R1.z, R2.y;
CMP R5.y, -R5.x, R4, R2.x;
ABS R3.x, R2.y;
MAD R2.y, R2.w, c[7].z, R3.w;
CMP R2.w, -R3.x, c[6].x, R1.y;
MOV R2.xz, c[6].x;
ADD R2.xyz, -R2, c[0];
MUL R3.xyz, -R2.zxyw, c[7].wwxw;
MAD R3.xyz, R2.yzxw, c[7].wxww, R3;
DP3 R3.y, R0, R3;
MUL R6.xyz, -R2.yzxw, c[7].xwww;
MAD R6.xyz, R2.zxyw, c[7].wxww, R6;
DP3 R3.x, R2, c[6].xwxw;
DP3 R3.z, R0, R6;
MUL R0.xyz, R4.w, R3;
MAD R0.zw, R0.xyyz, c[8].y, R0.w;
FLR R0.zw, R0;
ADD R2.xy, R0.zwzw, c[6].wxzw;
MUL R1.z, R1, R2.w;
SLT R5.w, R4.z, R5.y;
MUL R0.y, R1.z, R5.w;
CMP R1.z, -R0.y, R4, R5.y;
CMP R0.y, -R5.x, R4.z, R4;
MUL R2.z, R2.y, c[9].w;
MUL R2.w, R2.y, c[9].y;
MAD R2.y, R2.x, c[9].z, R2.z;
MAD R2.x, R2, c[9], R2.w;
ADD R0.y, R1.z, -R0;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R1.z, R2.y;
ABS R2.x, R2;
MAX R3.x, R2, R1.z;
SLT R3.y, R3.x, c[10].z;
ADD R1.z, R0.y, -c[10].w;
SLT R0.y, c[6].x, R0.x;
MUL R2.y, R0, R3;
CMP R2.z, -R2.y, R3.x, c[10];
ABS R2.x, R3.y;
CMP R2.w, -R2.x, c[6].x, R1.y;
MUL R2.y, R0.w, c[9];
MUL R2.x, R0.w, c[9].w;
MAD R3.z, R0, c[9].x, R2.y;
MAD R2.x, R0.z, c[9].z, R2;
COS R2.y, R2.x;
SIN R2.x, R3.z;
FRC R2.xy, R2;
MUL R3.z, R0.y, R2.w;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.w, R2.x, R2.y;
SLT R3.w, R2, R2.z;
MUL R2.x, R3.y, R3.z;
CMP R2.x, -R2, R3, c[10].z;
MUL R3.x, R0.y, R3.w;
CMP R3.y, -R3.x, R2.z, R2.x;
ABS R2.y, R3.w;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R3.w, R0.y, R2.x;
ADD R2.xy, R0.zwzw, c[7].xwzw;
SLT R3.z, R2.w, R3.y;
MUL R3.z, R3.w, R3;
CMP R2.z, -R3.x, R2.w, R2;
MUL R3.w, R2.y, c[9];
MUL R4.y, R2, c[9];
MAD R2.y, R2.x, c[9].z, R3.w;
MAD R2.x, R2, c[9], R4.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R3.x, R2, R2.y;
SLT R3.w, R3.x, R2.z;
CMP R2.x, -R3.z, R2.w, R3.y;
MUL R2.w, R0.y, R3;
CMP R3.y, -R2.w, R2.z, R2.x;
ABS R2.y, R3.w;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R3.w, R0.y, R2.x;
ADD R2.xy, R0.zwzw, c[10];
SLT R3.z, R3.x, R3.y;
MUL R3.z, R3.w, R3;
CMP R2.z, -R2.w, R3.x, R2;
MUL R3.w, R2.y, c[9];
MUL R4.y, R2, c[9];
MAD R2.y, R2.x, c[9].z, R3.w;
MAD R2.x, R2, c[9], R4.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.w, R2.x, R2.y;
SLT R3.w, R2, R2.z;
CMP R2.x, -R3.z, R3, R3.y;
MUL R3.y, R0, R3.w;
CMP R3.x, -R3.y, R2.z, R2;
ABS R2.y, R3.w;
CMP R2.x, -R2.y, c[6], R1.y;
MUL R3.w, R0.y, R2.x;
ADD R2.xy, R0.zwzw, c[7].wxzw;
SLT R3.z, R2.w, R3.x;
MUL R3.z, R3.w, R3;
ADD R0.zw, R0, c[7].x;
CMP R2.z, -R3.y, R2.w, R2;
MUL R4.y, R2, c[9];
MUL R3.w, R2.y, c[9];
MAD R2.y, R2.x, c[9].z, R3.w;
MAD R2.x, R2, c[9], R4.y;
COS R2.y, R2.y;
SIN R2.x, R2.x;
FRC R2.xy, R2;
ABS R2.y, R2;
ABS R2.x, R2;
MAX R2.x, R2, R2.y;
CMP R2.y, -R3.z, R2.w, R3.x;
SLT R3.y, R2.x, R2.z;
MUL R2.w, R0.y, R3.y;
CMP R2.y, -R2.w, R2.z, R2;
ABS R3.x, R3.y;
CMP R3.y, -R3.x, c[6].x, R1;
CMP R2.z, -R2.w, R2.x, R2;
SLT R3.x, R2, R2.y;
MUL R3.y, R0, R3;
MUL R3.x, R3.y, R3;
MUL R3.z, R0.w, c[9].y;
MUL R3.y, R0.w, c[9].w;
MAD R0.w, R0.z, c[9].z, R3.y;
MAD R0.z, R0, c[9].x, R3;
COS R0.w, R0.w;
SIN R0.z, R0.z;
FRC R0.zw, R0;
ABS R0.w, R0;
ABS R0.z, R0;
MAX R2.w, R0.z, R0;
SLT R0.w, R2, R2.z;
CMP R0.z, -R3.x, R2.x, R2.y;
ABS R2.y, R0.w;
MUL R2.x, R0.y, R0.w;
CMP R0.w, -R2.x, R2.z, R0.z;
CMP R2.y, -R2, c[6].x, R1;
MUL R0.y, R0, R2;
SLT R0.z, R2.w, R0.w;
MUL R0.z, R0.y, R0;
CMP R0.y, -R2.x, R2.w, R2.z;
CMP R0.z, -R0, R2.w, R0.w;
ADD R0.z, R0, -R0.y;
MUL R0.y, R1.z, c[11].x;
ADD R0.z, R0, -c[10].w;
POW R0.y, c[8].x, R0.y;
MAD R0.y, R0, c[11], R1.x;
MUL R0.w, R0.z, c[11].x;
CMP R0.z, -R4.x, R0.y, R1.x;
POW R0.y, c[8].x, R0.w;
MAD R0.y, R0, c[11], R0.z;
CMP R0.x, -R0, R0.y, R0.z;
ADD R0.y, -R1.w, c[7].x;
MAX R0.x, R0, R5.z;
MUL R2.xyz, R0.y, c[1];
ADD R1.xyz, R1.y, -c[1];
MAD R1.xyz, R1.w, R1, R2;
MUL result.color.xyz, R1, R0.x;
MOV result.depth.z, c[6].y;
MOV result.color.w, c[6].x;
END
# 800 instructions, 7 R-regs
"
}
SubProgram "d3d9 " {
// Stats: 291 math, 11 branches
Vector 0 [_WorldSpaceCameraPos]
Vector 1 [iPrimaryColor]
Float 2 [iFloorHeight]
Float 3 [iCeilingHeight]
Float 4 [iIntensity]
Float 5 [iIntensityTime]
"ps_3_0
def c6, -0.01348047, 0.05747731, -0.12123910, 0.19563590
def c7, -0.33299461, 0.99999559, 1.57079601, 3.14159298
def c8, 1.70000005, 16.00000000, 1.76821101, 0.50000000
def c9, 6.28318501, -3.14159298, 547.89001465, 4.00000000
def c10, 0.69999999, -0.20000000, 8.00000000, 0.25000000
def c11, 0.12500000, 5.00000000, 1.00000000, 0.00000000
def c12, 30.00000000, 11.00000000, 0.10000000, -5000.00000000
def c13, 0.00000000, -1.00000000, 2.00000000, 25000.00000000
defi i0, 5, 0, 1, 0
def c14, 0.00030000, 0.00010000, 180.00000000, -3.00000000
def c15, 4.40000010, 100.00000000, 500.00000000, 48.00000000
defi i1, 255, 0, 1, 0
def c16, 0.15915491, 0.50000000, 250.00000000, -0.02000000
def c17, -100.00000000, 2.71828198, 0.99989998, 0
dcl_texcoord1 v0.xyz
add r0.xyz, v0, -c0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
abs r1.w, r1.y
abs r0.x, r1
max r0.y, r0.x, r1.w
rcp r0.z, r0.y
min r0.y, r0.x, r1.w
mul r0.y, r0, r0.z
mul r0.z, r0.y, r0.y
add r0.x, r0, -r1.w
mad r0.w, r0.z, c6.x, c6.y
mad r0.w, r0, r0.z, c6.z
mad r0.w, r0, r0.z, c6
mad r0.w, r0, r0.z, c7.x
mad r0.z, r0.w, r0, c7.y
mul r0.y, r0.z, r0
add r0.z, -r0.y, c7
cmp r0.x, -r0, r0.y, r0.z
add r0.y, -r0.x, c7.w
cmp r0.x, r1.y, r0, r0.y
mov r0.z, c5.x
mul r2.y, c8.x, r0.z
cmp r2.x, r1, r0, -r0
mad r0.x, r2, c8.y, r2.y
frc r0.y, r0.x
add r0.x, r0, -r0.y
mad r0.x, r0, c8.z, c8.w
frc r0.x, r0
mad r2.z, r0.x, c9.x, c9.y
sincos r0.xy, r2.z
mad r0.z, r2.x, c10, -r2.y
mad r0.x, r2, c9.w, r2.y
mul r3.x, r0.y, c9.z
frc r0.y, r0.x
add r0.x, r0, -r0.y
frc r0.w, r0.z
add r0.y, r0.z, -r0.w
mad r0.x, r0, c8.z, c8.w
mad r0.y, r0, c8.z, c8.w
frc r0.y, r0
frc r0.x, r0
mad r0.x, r0, c9, c9.y
sincos r2.xy, r0.x
mad r3.y, r0, c9.x, c9
sincos r0.xy, r3.y
mul r0.x, r2.y, c9.z
mul r0.y, r0, c9.z
frc r0.z, r0.y
mov r0.y, c4.x
frc r0.x, r0
mul r0.z, r0, c10.w
mad r0.y, r0, c10.x, c10
mad r0.y, r0.x, r0, r0.z
frc r0.x, r3
mad r2.x, r0, c11, r0.y
pow r0, r2.x, c11.y
mov r0.y, c4.x
add r2.y, c11.z, -r0
mov r2.z, r0.x
mul r2.x, r1.y, r1.y
add r1.w, -r1, c11.z
mad r2.w, r2.y, c12.x, c12.y
pow r0, r1.w, r2.w
mul r0.y, r2.x, r2
mov r0.z, r0.x
rcp r0.y, r0.y
mul r0.x, r2.z, r0.y
mad r0.x, r0, c12.z, r0.z
mov r0.y, c2.x
add r0.w, c12, r0.y
mov r1.w, r0.x
mov r4.y, r0.x
mov r0.xz, c11.w
mov r0.y, r0.w
add r0.xyz, -r0, c0
dp3 r0.x, r0, c13.xyxw
rcp r2.x, r1.y
mul r0.x, r0, r2
cmp r3.z, -r0.x, c11, c11.w
add r0.y, -r0.w, c3.x
mad r3.w, r3.z, r0.y, r0
mad r4.x, r3.z, c13.z, c13.y
mov r4.z, c11.w
loop aL, i0
mul r0.y, r4.z, r4.x
mov r0.xz, c11.w
mad r0.y, r0, c13.w, r3.w
add r0.xyz, -r0, c0
mul r2.xyz, -r0.zxyw, c11.wwzw
mad r2.xyz, r0.yzxw, c11.wzww, r2
dp3 r2.y, r2, r1
mul r5.xyz, -r0.yzxw, c11.zwww
mad r5.xyz, r0.zxyw, c11.wzww, r5
dp3 r2.z, r1, r5
rcp r0.w, r1.y
dp3 r2.x, r0, c13.xyxw
mul r0.xyz, r2, r0.w
if_gt r0.x, c11.w
mov r0.x, c5
add r0.w, r4.z, c14
add r0.x, c14.z, r0
mul r0.x, r0, r0.w
mul r0.w, r0.x, c15.x
mad r0.x, r4.z, c14, c14.y
mad r0.xy, r0.yzzw, r0.x, r0.w
frc r0.zw, r0.xyxy
add r3.xy, r0, -r0.zwzw
mov r5.x, c10.z
mov r5.w, c10.z
mov r4.w, c11
loop aL, i1
break_gt r4.w, c11.z
mov r0.y, r4.w
mov r0.x, c13.y
add r0.xy, r3, r0
mul r0.z, r0.y, c15.w
mad r0.z, r0.x, c16, r0
mul r0.y, r0, c15
mad r0.x, r0, c15.z, r0.y
mad r0.y, r0.z, c16.x, c16
frc r0.y, r0
mad r0.x, r0, c16, c16.y
frc r0.x, r0
mad r2.x, r0.y, c9, c9.y
mad r5.y, r0.x, c9.x, c9
sincos r0.xy, r2.x
sincos r2.xy, r5.y
mov r0.y, r0.x
mov r0.x, r2.y
frc r0.xy, r0
abs r0.y, r0
abs r0.x, r0
max r5.y, r0.x, r0
add r5.z, r5.y, -r5.x
cmp r0.z, r5, r5.w, r5.x
add r0.x, r5.y, -r5
add r0.y, r5, -r0.z
cmp r0.x, r0, c11.w, c11.z
abs_pp r0.x, r0
cmp r5.x, r5.z, r5, r5.y
cmp r0.y, r0, c11.w, c11.z
cmp_pp r0.x, -r0, c11.z, c11.w
mul_pp r0.w, r0.x, r0.y
cmp r5.w, -r0, r0.z, r5.y
mov r0.y, r4.w
mov r0.x, c11.w
add r0.xy, r3, r0
mul r0.z, r0.y, c15.w
mad r0.z, r0.x, c16, r0
mul r0.y, r0, c15
mad r0.x, r0, c15.z, r0.y
mad r0.y, r0.z, c16.x, c16
frc r0.y, r0
mad r0.x, r0, c16, c16.y
frc r0.x, r0
mad r2.x, r0.y, c9, c9.y
mad r6.x, r0, c9, c9.y
sincos r0.xy, r2.x
sincos r2.xy, r6.x
mov r0.y, r0.x
mov r0.x, r2.y
frc r0.xy, r0
abs r0.y, r0
abs r0.x, r0
max r5.y, r0.x, r0
add r5.z, r5.y, -r5.x
cmp r0.z, r5, r5.w, r5.x
add r0.x, r5.y, -r5
add r0.y, r5, -r0.z
cmp r0.x, r0, c11.w, c11.z
abs_pp r0.x, r0
cmp r0.y, r0, c11.w, c11.z
cmp_pp r0.x, -r0, c11.z, c11.w
mul_pp r0.w, r0.x, r0.y
mov r0.y, r4.w
mov r0.x, c11.z
add r0.xy, r3, r0
cmp r5.w, -r0, r0.z, r5.y
mul r0.z, r0.y, c15.w
mad r0.z, r0.x, c16, r0
mul r0.y, r0, c15
mad r0.x, r0, c15.z, r0.y
mad r0.y, r0.z, c16.x, c16
frc r0.y, r0
mad r0.x, r0, c16, c16.y
frc r0.x, r0
mad r2.x, r0.y, c9, c9.y
mad r6.x, r0, c9, c9.y
sincos r0.xy, r2.x
sincos r2.xy, r6.x
cmp r0.z, r5, r5.x, r5.y
mov r0.y, r0.x
mov r0.x, r2.y
frc r0.xy, r0
abs r0.y, r0
abs r0.x, r0
max r0.x, r0, r0.y
add r0.y, r0.x, -r0.z
cmp r2.x, r0.y, r5.w, r0.z
add r0.w, r0.x, -r0.z
cmp r0.w, r0, c11, c11.z
add r2.y, r0.x, -r2.x
abs_pp r0.w, r0
cmp r2.y, r2, c11.w, c11.z
cmp_pp r0.w, -r0, c11.z, c11
mul_pp r0.w, r0, r2.y
cmp r5.w, -r0, r2.x, r0.x
cmp r5.x, r0.y, r0.z, r0
add r4.w, r4, c11.z
endloop
add r0.x, r5.w, -r5
add r0.x, r0, c16.w
mul r2.x, r0, c17
pow r0, c17.y, r2.x
mad r1.w, r0.x, c12.z, r1
endif
add r4.z, r4, c11
endloop
add r0.w, -r3.z, c11.z
mul r1.xyz, r0.w, c1
mov r0.xyz, c1
add r0.xyz, c11.z, -r0
max r0.w, r1, r4.y
mad r0.xyz, r3.z, r0, r1
mul oC0.xyz, r0, r0.w
mov oC0.w, c11
mov oDepth, c17.z
"
}
SubProgram "d3d11 " {
// Stats: 106 math, 4 branches
ConstBuffer "$Globals" 176
Vector 16 [iPrimaryColor]
Float 32 [iFloorHeight]
Float 36 [iCeilingHeight]
Float 40 [iIntensity]
Float 44 [iIntensityTime]
ConstBuffer "UnityPerCamera" 128
Vector 64 [_WorldSpaceCameraPos] 3
BindCB  "$Globals" 0
BindCB  "UnityPerCamera" 1
"ps_4_0
eefiecedinmemjhjmpbobfkpeahgnicgjbgkdnagabaaaaaahebaaaaaadaaaaaa
cmaaaaaajmaaaaaaoiaaaaaaejfdeheogiaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaafmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
eeaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaadiaaaaaaabaaaaaaaaaaaaaaadaaaaaaabaaaaaaabaoaaaafdfgfpfe
gbhcghgfheaaklklfdeieefcieapaaaaeaaaaaaaobadaaaafjaaaaaeegiocaaa
aaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaagcbaaaadhcbabaaa
acaaaaaagfaaaaadpccabaaaaaaaaaaagfaaaaadbccabaaaabaaaaaagiaaaaac
aiaaaaaaaaaaaaajhcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaiaebaaaaaa
abaaaaaaaeaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaa
aaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
aaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaaaaaaaaaiicaabaaaaaaaaaaa
bkaabaiambaaaaaaaaaaaaaaabeaaaaaaaaaiadpaaaaaaajbcaabaaaabaaaaaa
ckiacaiaebaaaaaaaaaaaaaaacaaaaaaabeaaaaaaaaaiadpdcaaaaajccaabaaa
abaaaaaaakaabaaaabaaaaaaabeaaaaaaaaapaebabeaaaaaaaaadaebcpaaaaaf
icaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahicaabaaaaaaaaaaadkaabaaa
aaaaaaaabkaabaaaabaaaaaabjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
ddaaaaajccaabaaaabaaaaaabkaabaiaibaaaaaaaaaaaaaaakaabaiaibaaaaaa
aaaaaaaadeaaaaajecaabaaaabaaaaaabkaabaiaibaaaaaaaaaaaaaaakaabaia
ibaaaaaaaaaaaaaaaoaaaaakecaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpckaabaaaabaaaaaadiaaaaahccaabaaaabaaaaaackaabaaa
abaaaaaabkaabaaaabaaaaaadiaaaaahecaabaaaabaaaaaabkaabaaaabaaaaaa
bkaabaaaabaaaaaadcaaaaajicaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaa
fpkokkdmabeaaaaadgfkkolndcaaaaajicaabaaaabaaaaaackaabaaaabaaaaaa
dkaabaaaabaaaaaaabeaaaaaochgdidodcaaaaajicaabaaaabaaaaaackaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaebnkjlodcaaaaajecaabaaaabaaaaaa
ckaabaaaabaaaaaadkaabaaaabaaaaaaabeaaaaadiphhpdpdiaaaaahicaabaaa
abaaaaaackaabaaaabaaaaaabkaabaaaabaaaaaadbaaaaajbcaabaaaacaaaaaa
bkaabaiaibaaaaaaaaaaaaaaakaabaiaibaaaaaaaaaaaaaadcaaaaajicaabaaa
abaaaaaadkaabaaaabaaaaaaabeaaaaaaaaaaamaabeaaaaanlapmjdpabaaaaah
icaabaaaabaaaaaaakaabaaaacaaaaaadkaabaaaabaaaaaadcaaaaajccaabaaa
abaaaaaabkaabaaaabaaaaaackaabaaaabaaaaaadkaabaaaabaaaaaadbaaaaai
ecaabaaaabaaaaaabkaabaaaaaaaaaaabkaabaiaebaaaaaaaaaaaaaaabaaaaah
ecaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaanlapejmaaaaaaaahccaabaaa
abaaaaaackaabaaaabaaaaaabkaabaaaabaaaaaaddaaaaahecaabaaaabaaaaaa
bkaabaaaaaaaaaaaakaabaaaaaaaaaaadeaaaaahicaabaaaabaaaaaabkaabaaa
aaaaaaaaakaabaaaaaaaaaaadbaaaaaiecaabaaaabaaaaaackaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabnaaaaaiicaabaaaabaaaaaadkaabaaaabaaaaaa
dkaabaiaebaaaaaaabaaaaaaabaaaaahecaabaaaabaaaaaadkaabaaaabaaaaaa
ckaabaaaabaaaaaadhaaaaakccaabaaaabaaaaaackaabaaaabaaaaaabkaabaia
ebaaaaaaabaaaaaabkaabaaaabaaaaaadiaaaaaiecaabaaaabaaaaaadkiacaaa
aaaaaaaaacaaaaaaabeaaaaajkjjnjdpdcaaaaamdcaabaaaacaaaaaafgafbaaa
abaaaaaaaceaaaaaaaaaiaeaaaaaiaebaaaaaaaaaaaaaaaakgakbaaaabaaaaaa
ebaaaaafdcaabaaaacaaaaaaegaabaaaacaaaaaadiaaaaakdcaabaaaacaaaaaa
egaabaaaacaaaaaaaceaaaaaipmcdbebipmcdbebaaaaaaaaaaaaaaaaenaaaaag
dcaabaaaacaaaaaaaanaaaaaegaabaaaacaaaaaadiaaaaakdcaabaaaacaaaaaa
egaabaaaacaaaaaaaceaaaaapgpiaieepgpiaieeaaaaaaaaaaaaaaaabkaaaaaf
dcaabaaaacaaaaaaegaabaaaacaaaaaadcaaaaakicaabaaaabaaaaaackiacaaa
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
ckaabaaaabaaaaaabkaabaaaabaaaaaadiaaaaahecaabaaaabaaaaaabkaabaaa
aaaaaaaabkaabaaaaaaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaa
ckaabaaaabaaaaaaaoaaaaakbcaabaaaabaaaaaaaceaaaaaaaaaiadpaaaaiadp
aaaaiadpaaaaiadpakaabaaaabaaaaaadiaaaaahbcaabaaaabaaaaaaakaabaaa
abaaaaaabkaabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaaakaabaaaabaaaaaa
abeaaaaamnmmmmdndkaabaaaaaaaaaaaaaaaaaaldcaabaaaabaaaaaamgiacaaa
aaaaaaaaacaaaaaaaceaaaaaaaeajmmfaaaadeedaaaaaaaaaaaaaaaaaaaaaaaj
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaabkiacaaaabaaaaaaaeaaaaaa
aoaaaaaiecaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaabkaabaaaaaaaaaaa
bnaaaaahecaabaaaabaaaaaaabeaaaaaaaaaaaaackaabaaaabaaaaaaabaaaaah
icaabaaaabaaaaaackaabaaaabaaaaaaabeaaaaaaaaaiadpaaaaaaajbcaabaaa
acaaaaaaakaabaiaebaaaaaaabaaaaaabkiacaaaaaaaaaaaacaaaaaadcaaaaaj
bcaabaaaabaaaaaadkaabaaaabaaaaaaakaabaaaacaaaaaaakaabaaaabaaaaaa
dhaaaaajbcaabaaaacaaaaaackaabaaaabaaaaaaabeaaaaaaaaaiadpabeaaaaa
aaaaialpdgaaaaailcaabaaaadaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaadgaaaaafccaabaaaacaaaaaadkaabaaaaaaaaaaadgaaaaafecaabaaa
acaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaacaaaaaackaabaaa
acaaaaaaabeaaaaaafaaaaaaadaaaeaddkaabaaaacaaaaaaclaaaaaficaabaaa
acaaaaaackaabaaaacaaaaaadiaaaaahbcaabaaaaeaaaaaaakaabaaaacaaaaaa
dkaabaaaacaaaaaadcaaaaajecaabaaaadaaaaaaakaabaaaaeaaaaaaabeaaaaa
aafamdegakaabaaaabaaaaaaaaaaaaajpcaabaaaaeaaaaaaegaobaiaebaaaaaa
adaaaaaacgijcaaaabaaaaaaaeaaaaaadgaaaaagbcaabaaaafaaaaaackaabaia
ebaaaaaaaeaaaaaadiaaaaakdcaabaaaagaaaaaajgafbaaaaeaaaaaaaceaaaaa
aaaaaaaaaaaaiadpaaaaaaaaaaaaaaaadcaaaaandcaabaaaagaaaaaahgapbaaa
aeaaaaaaaceaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaegaabaiaebaaaaaa
agaaaaaaapaaaaahccaabaaaafaaaaaaegaabaaaagaaaaaajgafbaaaaaaaaaaa
diaaaaakmcaabaaaaeaaaaaakgaobaaaaeaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaiadpaaaaaaaadcaaaaandcaabaaaaeaaaaaaegaabaaaaeaaaaaaaceaaaaa
aaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaogakbaiaebaaaaaaaeaaaaaaapaaaaah
ecaabaaaafaaaaaaegaabaaaaeaaaaaaegaabaaaaaaaaaaaaoaaaaahhcaabaaa
aeaaaaaaegacbaaaafaaaaaafgafbaaaaaaaaaaadbaaaaahecaabaaaadaaaaaa
abeaaaaaaaaaaaaaakaabaaaaeaaaaaabpaaaeadckaabaaaadaaaaaadcaaaaaj
ecaabaaaadaaaaaadkaabaaaacaaaaaaabeaaaaafcejjndjabeaaaaabhlhnbdi
aaaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaaaaaaeamadiaaaaah
icaabaaaacaaaaaabkaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaamnmmimeadcaaaaajdcaabaaaaeaaaaaa
jgafbaaaaeaaaaaakgakbaaaadaaaaaapgapbaaaacaaaaaaebaaaaafdcaabaaa
aeaaaaaaegaabaaaaeaaaaaadgaaaaaimcaabaaaaeaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaebaaaaaaebdgaaaaaficaabaaaacaaaaaaabeaaaaaaaaaaaaa
daaaaaabccaaaaahecaabaaaadaaaaaaabeaaaaaabaaaaaadkaabaaaacaaaaaa
adaaaeadckaabaaaadaaaaaaclaaaaafccaabaaaafaaaaaadkaabaaaacaaaaaa
dgaaaaafmcaabaaaafaaaaaakgaobaaaaeaaaaaadgaaaaafecaabaaaadaaaaaa
abeaaaaappppppppdaaaaaabccaaaaahbcaabaaaagaaaaaaabeaaaaaabaaaaaa
ckaabaaaadaaaaaaadaaaeadakaabaaaagaaaaaaclaaaaafbcaabaaaafaaaaaa
ckaabaaaadaaaaaaaaaaaaahdcaabaaaagaaaaaaegaabaaaaeaaaaaaegaabaaa
afaaaaaaapaaaaakbcaabaaaafaaaaaaegaabaaaagaaaaaaaceaaaaaaaaapked
aaaamiecaaaaaaaaaaaaaaaaenaaaaagbcaabaaaafaaaaaaaanaaaaaakaabaaa
afaaaaaaapaaaaakbcaabaaaagaaaaaaegaabaaaagaaaaaaaceaaaaaaaaahked
aaaaeaecaaaaaaaaaaaaaaaaenaaaaagaanaaaaabcaabaaaagaaaaaaakaabaaa
agaaaaaabkaaaaafbcaabaaaafaaaaaaakaabaaaafaaaaaabkaaaaafbcaabaaa
agaaaaaaakaabaaaagaaaaaadeaaaaahbcaabaaaagaaaaaaakaabaaaafaaaaaa
akaabaaaagaaaaaadbaaaaahdcaabaaaahaaaaaaagaabaaaagaaaaaaogakbaaa
afaaaaaadhaaaaajecaabaaaagaaaaaabkaabaaaahaaaaaaakaabaaaagaaaaaa
dkaabaaaafaaaaaadgaaaaafccaabaaaagaaaaaackaabaaaafaaaaaadhaaaaaj
mcaabaaaafaaaaaaagaabaaaahaaaaaaagaebaaaagaaaaaafgajbaaaagaaaaaa
boaaaaahecaabaaaadaaaaaackaabaaaadaaaaaaabeaaaaaabaaaaaabgaaaaab
dgaaaaafmcaabaaaaeaaaaaakgaobaaaafaaaaaaboaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaaiicaabaaaacaaaaaa
ckaabaiaebaaaaaaaeaaaaaadkaabaaaaeaaaaaaaaaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaaknhkdlmdiaaaaahicaabaaaacaaaaaadkaabaaa
acaaaaaaabeaaaaapoeebamdbjaaaaaficaabaaaacaaaaaadkaabaaaacaaaaaa
dcaaaaajccaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaamnmmmmdnbkaabaaa
acaaaaaabfaaaaabboaaaaahecaabaaaacaaaaaackaabaaaacaaaaaaabeaaaaa
abaaaaaabgaaaaabdeaaaaahbcaabaaaaaaaaaaadkaabaaaaaaaaaaabkaabaaa
acaaaaaaaaaaaaamocaabaaaaaaaaaaaagijcaiaebaaaaaaaaaaaaaaabaaaaaa
aceaaaaaaaaaaaaaaaaaiadpaaaaiadpaaaaiadpdhaaaaanhcaabaaaabaaaaaa
kgakbaaaabaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaegiccaaa
aaaaaaaaabaaaaaadcaaaaajocaabaaaaaaaaaaapgapbaaaabaaaaaafgaobaaa
aaaaaaaaagajbaaaabaaaaaadiaaaaahhccabaaaaaaaaaaaagaabaaaaaaaaaaa
jgahbaaaaaaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaaaaadgaaaaaf
bccabaaaabaaaaaaabeaaaaahcpjhpdpdoaaaaab"
}
SubProgram "gles3 " {
"!!GLES3"
}
}
 }
}
Fallback "Diffuse"
}