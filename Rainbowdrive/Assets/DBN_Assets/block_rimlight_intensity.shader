// DeathByNukes
// modified block_rimlight to make the border color a greyscale color based on a single float value

Shader "block_rimlight_intensity" {
Properties {
	_MainTex ("Base (RGB) (only used in the fallback shader)", 2D) = "black" {}
	_Color ("Block Color", Color) = (1,1,1,1)
	_BorderGreyscale ("Border Color Brightness (greyscale)", Range(0.0,1.0)) = 1
	_RimColor ("Rim Color", Color) = (0.25,0.25,0.25,0.0)
	_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {  
		Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 32 to 32
//   d3d9 - ALU: 40 to 40
//   d3d11 - ALU: 16 to 16, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 16 to 16, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_Color]
Float 12 [_BorderGreyscale]
Vector 13 [_RimColor]
Float 14 [_RimPower]
"!!ARBvp1.0
# 32 ALU
PARAM c[15] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[9];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
DP3 R1.x, vertex.normal, vertex.normal;
RSQ R1.x, R1.x;
MUL R0.xyz, R0.w, R0;
MUL R1.xyz, R1.x, vertex.normal;
DP3 R0.x, R0, R1;
MIN R0.x, R0, c[0];
MAX R0.x, R0, c[0].y;
ADD R0.x, -R0, c[0];
ABS R0.z, vertex.texcoord[0].y;
ABS R0.y, vertex.texcoord[0].x;
SGE R0.z, c[0].y, R0;
SGE R0.y, c[0], R0;
MUL R1.x, R0.y, R0.z;
POW R0.x, R0.x, c[14].x;
MUL R0, R0.x, c[13];
ABS R1.x, R1;
ADD R0, R0, c[11];
SGE R1.x, c[0].y, R1;
ADD R0, R0, -c[12].x;
MAD result.color, R0, R1.x, c[12].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 32 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_Color]
Float 11 [_BorderGreyscale]
Vector 12 [_RimColor]
Float 13 [_RimPower]
"vs_2_0
; 40 ALU
def c14, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c8
mov r1.w, c14.y
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, v1, v1
rsq r1.x, r1.x
mul r0.xyz, r0.w, r0
mul r1.xyz, r1.x, v1
dp3 r0.x, r0, r1
min r0.x, r0, c14.y
max r0.w, r0.x, c14.x
add r1.x, -r0.w, c14.y
sge r0.y, c14.x, v2
sge r0.x, v2.y, c14
mul r0.z, r0.x, r0.y
sge r0.y, c14.x, v2.x
sge r0.x, v2, c14
mul r0.x, r0, r0.y
mul r0.x, r0, r0.z
sge r0.y, c14.x, r0.x
sge r0.x, r0, c14
mul r1.y, r0.x, r0
pow r0, r1.x, c13.x
max r0.y, -r1, r1
slt r1.x, c14, r0.y
add r1.y, -r1.x, c14
mul r0, r0.x, c12
mul r1.y, r1, c11.x
add r0, r0, c10
mad oD0, r1.x, r0, r1.y
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80 // 68 used size, 5 vars
Vector 16 [_Color] 4
Float 32 [_BorderGreyscale]
Vector 48 [_RimColor] 4
Float 64 [_RimPower]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 25 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedkkfdlochgknokkbgemkjjfhbpkeenbgfabaaaaaajeaeaaaaadaaaaaa
cmaaaaaakaaaaaaapeaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaaedepemepfcaaklklfdeieefcjiadaaaaeaaaabaa
ogaaaaaafjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagiaaaaacacaaaaaadiaaaaai
pcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaa
aaaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
aaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaa
aaaaaaaapgipcaaaacaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaah
icaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaa
aaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaa
egacbaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaa
abaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaa
abaaaaaapgapbaaaaaaaaaaaegbcbaaaabaaaaaabacaaaahbcaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaabaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaia
ebaaaaaaaaaaaaaaabeaaaaaaaaaiadpcpaaaaafbcaabaaaaaaaaaaaakaabaaa
aaaaaaaadiaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaa
aeaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaadaaaaaaagaabaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaabiaaaaakdcaabaaaabaaaaaaegbabaaaacaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaabaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaa
akaabaaaabaaaaaadhaaaaakpccabaaaabaaaaaaagaabaaaabaaaaaaagiacaaa
aaaaaaaaacaaaaaaegaobaaaaaaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec4 xlv_COLOR;
uniform highp float _RimPower;
uniform lowp vec4 _RimColor;
uniform lowp float _BorderGreyscale;
uniform lowp vec4 _Color;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  if (((_glesMultiTexCoord0.x == 0.0) && (_glesMultiTexCoord0.y == 0.0))) {
    lowp vec4 tmpvar_4;
    tmpvar_4.x = _BorderGreyscale;
    tmpvar_4.y = _BorderGreyscale;
    tmpvar_4.z = _BorderGreyscale;
    tmpvar_4.w = _BorderGreyscale;
    tmpvar_2 = tmpvar_4;
  } else {
    mediump float rim_5;
    highp vec4 tmpvar_6;
    tmpvar_6.w = 1.0;
    tmpvar_6.xyz = _WorldSpaceCameraPos;
    highp float tmpvar_7;
    tmpvar_7 = (1.0 - clamp (dot (normalize((((_World2Object * tmpvar_6).xyz * unity_Scale.w) - _glesVertex.xyz)), normalize(tmpvar_1)), 0.0, 1.0));
    rim_5 = tmpvar_7;
    highp vec4 tmpvar_8;
    tmpvar_8 = (_Color + (_RimColor * pow (rim_5, _RimPower)));
    tmpvar_2 = tmpvar_8;
  };
  gl_Position = tmpvar_3;
  xlv_COLOR = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES


#ifdef VERTEX

varying lowp vec4 xlv_COLOR;
uniform highp float _RimPower;
uniform lowp vec4 _RimColor;
uniform lowp float _BorderGreyscale;
uniform lowp vec4 _Color;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  lowp vec4 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (glstate_matrix_mvp * _glesVertex);
  if (((_glesMultiTexCoord0.x == 0.0) && (_glesMultiTexCoord0.y == 0.0))) {
    lowp vec4 tmpvar_4;
    tmpvar_4.x = _BorderGreyscale;
    tmpvar_4.y = _BorderGreyscale;
    tmpvar_4.z = _BorderGreyscale;
    tmpvar_4.w = _BorderGreyscale;
    tmpvar_2 = tmpvar_4;
  } else {
    mediump float rim_5;
    highp vec4 tmpvar_6;
    tmpvar_6.w = 1.0;
    tmpvar_6.xyz = _WorldSpaceCameraPos;
    highp float tmpvar_7;
    tmpvar_7 = (1.0 - clamp (dot (normalize((((_World2Object * tmpvar_6).xyz * unity_Scale.w) - _glesVertex.xyz)), normalize(tmpvar_1)), 0.0, 1.0));
    rim_5 = tmpvar_7;
    highp vec4 tmpvar_8;
    tmpvar_8 = (_Color + (_RimColor * pow (rim_5, _RimPower)));
    tmpvar_2 = tmpvar_8;
  };
  gl_Position = tmpvar_3;
  xlv_COLOR = tmpvar_2;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR;
void main ()
{
  gl_FragData[0] = xlv_COLOR;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_Color]
Float 11 [_BorderGreyscale]
Vector 12 [_RimColor]
Float 13 [_RimPower]
"agal_vs
c14 0.0 1.0 0.0 0.0
[bc]
aaaaaaaaabaaahacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c8
aaaaaaaaabaaaiacaoaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c14.y
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 r0.z, r1, c6
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, r1, c4
bdaaaaaaaaaaacacabaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r0.y, r1, c5
adaaaaaaacaaahacaaaaaakeacaaaaaaajaaaappabaaaaaa mul r2.xyz, r0.xyzz, c9.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
bcaaaaaaabaaabacabaaaaoeaaaaaaaaabaaaaoeaaaaaaaa dp3 r1.x, a1, a1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
adaaaaaaabaaahacabaaaaaaacaaaaaaabaaaaoeaaaaaaaa mul r1.xyz, r1.x, a1
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
agaaaaaaaaaaabacaaaaaaaaacaaaaaaaoaaaaffabaaaaaa min r0.x, r0.x, c14.y
ahaaaaaaaaaaaiacaaaaaaaaacaaaaaaaoaaaaaaabaaaaaa max r0.w, r0.x, c14.x
bfaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r2.w, r0.w
abaaaaaaabaaabacacaaaappacaaaaaaaoaaaaffabaaaaaa add r1.x, r2.w, c14.y
cjaaaaaaaaaaacacaoaaaaaaabaaaaaaadaaaaoeaaaaaaaa sge r0.y, c14.x, a3
cjaaaaaaaaaaabacadaaaaffaaaaaaaaaoaaaaoeabaaaaaa sge r0.x, a3.y, c14
adaaaaaaaaaaaeacaaaaaaaaacaaaaaaaaaaaaffacaaaaaa mul r0.z, r0.x, r0.y
cjaaaaaaaaaaacacaoaaaaaaabaaaaaaadaaaaaaaaaaaaaa sge r0.y, c14.x, a3.x
cjaaaaaaaaaaabacadaaaaoeaaaaaaaaaoaaaaoeabaaaaaa sge r0.x, a3, c14
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaffacaaaaaa mul r0.x, r0.x, r0.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaakkacaaaaaa mul r0.x, r0.x, r0.z
cjaaaaaaaaaaacacaoaaaaaaabaaaaaaaaaaaaaaacaaaaaa sge r0.y, c14.x, r0.x
cjaaaaaaaaaaabacaaaaaaaaacaaaaaaaoaaaaoeabaaaaaa sge r0.x, r0.x, c14
adaaaaaaabaaacacaaaaaaaaacaaaaaaaaaaaaffacaaaaaa mul r1.y, r0.x, r0.y
alaaaaaaaaaaapacabaaaaaaacaaaaaaanaaaaaaabaaaaaa pow r0, r1.x, c13.x
bfaaaaaaaaaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa neg r0.y, r1.y
ahaaaaaaaaaaacacaaaaaaffacaaaaaaabaaaaffacaaaaaa max r0.y, r0.y, r1.y
ckaaaaaaabaaabacaoaaaaoeabaaaaaaaaaaaaffacaaaaaa slt r1.x, c14, r0.y
bfaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r2.x, r1.x
abaaaaaaabaaacacacaaaaaaacaaaaaaaoaaaaoeabaaaaaa add r1.y, r2.x, c14
adaaaaaaaaaaapacaaaaaaaaacaaaaaaamaaaaoeabaaaaaa mul r0, r0.x, c12
adaaaaaaabaaacacabaaaaffacaaaaaaalaaaaaaabaaaaaa mul r1.y, r1.y, c11.x
abaaaaaaaaaaapacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa add r0, r0, c10
adaaaaaaacaaapacabaaaaaaacaaaaaaaaaaaaoeacaaaaaa mul r2, r1.x, r0
abaaaaaaahaaapaeacaaaaoeacaaaaaaabaaaaffacaaaaaa add v7, r2, r1.y
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 80 // 68 used size, 5 vars
Vector 16 [_Color] 4
Float 32 [_BorderGreyscale]
Vector 48 [_RimColor] 4
Float 64 [_RimPower]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 25 instructions, 2 temp regs, 0 temp arrays:
// ALU 15 float, 0 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_1
eefiecedohmcbmajmdlbmghcpncgofehfahpglecabaaaaaaomagaaaaaeaaaaaa
daaaaaaaieacaaaaceagaaaajiagaaaaebgpgodjemacaaaaemacaaaaaaacpopp
peabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaabaa
aeaaabaaaaaaaaaaabaaaeaaabaaafaaaaaaaaaaacaaaaaaaeaaagaaaaaaaaaa
acaabaaaafaaakaaaaaaaaaaaaaaaaaaaaacpoppfbaaaaafapaaapkaaaaaaaaa
aaaaiadpaaaaaaaaaaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabia
abaaapjabpaaaaacafaaaciaacaaapjaabaaaaacaaaaahiaafaaoekaafaaaaad
abaaahiaaaaaffiaalaaoekaaeaaaaaeaaaaaliaakaakekaaaaaaaiaabaakeia
aeaaaaaeaaaaahiaamaaoekaaaaakkiaaaaapeiaacaaaaadaaaaahiaaaaaoeia
anaaoekaaeaaaaaeaaaaahiaaaaaoeiaaoaappkaaaaaoejbceaaaaacabaaahia
aaaaoeiaceaaaaacaaaaahiaabaaoejaaiaaaaadaaaaabiaabaaoeiaaaaaoeia
alaaaaadaaaaabiaaaaaaaiaapaaaakaakaaaaadaaaaabiaaaaaaaiaapaaffka
acaaaaadaaaaabiaaaaaaaibapaaffkacaaaaaadabaaabiaaaaaaaiaaeaaaaka
abaaaaacaaaaapiaadaaoekaaeaaaaaeaaaaapiaaaaaoeiaabaaaaiaabaaoeka
acaaaaadabaaapiaaaaaoeibacaaaakaafaaaaadacaaadiaacaaoejaacaaoeja
anaaaaadacaaadiaacaaoeibacaaoeiaafaaaaadacaaabiaacaaffiaacaaaaia
aeaaaaaeaaaaapoaacaaaaiaabaaoeiaaaaaoeiaafaaaaadaaaaapiaaaaaffja
ahaaoekaaeaaaaaeaaaaapiaagaaoekaaaaaaajaaaaaoeiaaeaaaaaeaaaaapia
aiaaoekaaaaakkjaaaaaoeiaaeaaaaaeaaaaapiaajaaoekaaaaappjaaaaaoeia
aeaaaaaeaaaaadmaaaaappiaaaaaoekaaaaaoeiaabaaaaacaaaaammaaaaaoeia
ppppaaaafdeieefcjiadaaaaeaaaabaaogaaaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaabaaaaaafpaaaaad
dcbabaaaacaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaagfaaaaadpccabaaa
abaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaa
egiocaaaacaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaa
aaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaacaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pccabaaaaaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaa
aaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaaaeaaaaaaegiccaaa
acaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabaaaaaaa
agiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaa
aaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaacaaaaaabdaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaaacaaaaaabeaaaaaa
egbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaa
egacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaah
hcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegbcbaaa
abaaaaaabacaaaahbcaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaabaaaaaa
aaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaaaaaaiadp
cpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaaibcaabaaaaaaaaaaa
akaabaaaaaaaaaaaakiacaaaaaaaaaaaaeaaaaaabjaaaaafbcaabaaaaaaaaaaa
akaabaaaaaaaaaaadcaaaaalpcaabaaaaaaaaaaaegiocaaaaaaaaaaaadaaaaaa
agaabaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaabiaaaaakdcaabaaaabaaaaaa
egbabaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabaaaaah
bcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaaabaaaaaadhaaaaakpccabaaa
abaaaaaaagaabaaaabaaaaaaagiacaaaaaaaaaaaacaaaaaaegaobaaaaaaaaaaa
doaaaaabejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
ahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaadadaaaafaepfdej
feejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklklepfdeheoemaaaaaa
acaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaa
eeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaafdfgfpfaepfdejfe
ejepeoaaedepemepfcaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 313
struct v2f {
    highp vec4 vertex;
    lowp vec4 color;
};
#line 306
struct appdata_t {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec2 texcoord;
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
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 319
uniform lowp vec4 _Color;
uniform lowp float _BorderGreyscale;
uniform lowp vec4 _RimColor;
uniform highp float _RimPower;
#line 323
#line 338
#line 90
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 323
v2f vert( in appdata_t v ) {
    v2f o;
    o.vertex = (glstate_matrix_mvp * v.vertex);
    #line 327
    if (((v.texcoord.x == 0.0) && (v.texcoord.y == 0.0))){
        o.color = vec4( _BorderGreyscale, _BorderGreyscale, _BorderGreyscale, _BorderGreyscale);
    }
    else{
        #line 333
        mediump float rim = (1.0 - xll_saturate_f(dot( normalize(ObjSpaceViewDir( v.vertex)), normalize(v.normal))));
        o.color = (_Color + (_RimColor * pow( rim, _RimPower)));
    }
    return o;
}
out lowp vec4 xlv_COLOR;
void main() {
    v2f xl_retval;
    appdata_t xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec2(gl_MultiTexCoord0);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.vertex);
    xlv_COLOR = vec4(xl_retval.color);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

#line 150
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 186
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 180
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 313
struct v2f {
    highp vec4 vertex;
    lowp vec4 color;
};
#line 306
struct appdata_t {
    highp vec4 vertex;
    highp vec3 normal;
    highp vec2 texcoord;
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
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_LightPosition[4];
uniform highp vec4 unity_LightAtten[4];
#line 19
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_SHBr;
#line 23
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
#line 27
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
uniform highp vec4 _LightSplitsNear;
#line 31
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
#line 35
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 _Object2World;
#line 39
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
uniform highp mat4 glstate_matrix_texture0;
#line 43
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
uniform highp mat4 glstate_matrix_projection;
#line 47
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform lowp vec4 unity_ColorSpaceGrey;
#line 76
#line 81
#line 86
#line 90
#line 95
#line 119
#line 136
#line 157
#line 165
#line 192
#line 205
#line 214
#line 219
#line 228
#line 233
#line 242
#line 259
#line 264
#line 290
#line 298
#line 302
#line 319
uniform lowp vec4 _Color;
uniform lowp float _BorderGreyscale;
uniform lowp vec4 _RimColor;
uniform highp float _RimPower;
#line 323
#line 338
#line 338
lowp vec4 frag( in v2f i ) {
    return i.color;
}
in lowp vec4 xlv_COLOR;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.vertex = vec4(0.0);
    xlt_i.color = vec4(xlv_COLOR);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 1 to 1, TEX: 0 to 0
//   d3d9 - ALU: 1 to 1
//   d3d11 - ALU: 0 to 0, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 0 to 0, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
"!!ARBfp1.0
# 1 ALU, 0 TEX
MOV result.color, fragment.color.primary;
END
# 1 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
"ps_2_0
; 1 ALU
dcl v0
mov_pp oC0, v0
"
}

SubProgram "d3d11 " {
Keywords { }
// 2 instructions, 0 temp regs, 0 temp arrays:
// ALU 0 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefiecedfjdoiaijdeijhjdpnpibjbpjbcgfffpfabaaaaaapeaaaaaaadaaaaaa
cmaaaaaaiaaaaaaaleaaaaaaejfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapapaaaafdfgfpfaepfdejfeejepeoaaedepemepfcaaklkl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcdiaaaaaaeaaaaaaa
aoaaaaaagcbaaaadpcbabaaaabaaaaaagfaaaaadpccabaaaaaaaaaaadgaaaaaf
pccabaaaaaaaaaaaegbobaaaabaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
"agal_ps
[bc]
aaaaaaaaaaaaapadahaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov o0, v7
"
}

SubProgram "d3d11_9x " {
Keywords { }
// 2 instructions, 0 temp regs, 0 temp arrays:
// ALU 0 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_1
eefiecedmdmomhldiedflkcimhkfbplmajbggmfnabaaaaaaeeabaaaaaeaaaaaa
daaaaaaahmaaaaaalmaaaaaabaabaaaaebgpgodjeeaaaaaaeeaaaaaaaaacpppp
caaaaaaaceaaaaaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaaaceaaaaacpppp
bpaaaaacaaaaaaiaaaaacplaabaaaaacaaaicpiaaaaaoelappppaaaafdeieefc
diaaaaaaeaaaaaaaaoaaaaaagcbaaaadpcbabaaaabaaaaaagfaaaaadpccabaaa
aaaaaaaadgaaaaafpccabaaaaaaaaaaaegbobaaaabaaaaaadoaaaaabejfdeheo
emaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaa
apaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapapaaaafdfgfpfa
epfdejfeejepeoaaedepemepfcaaklklepfdeheocmaaaaaaabaaaaaaaiaaaaaa
caaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaafdfgfpfegbhcghgf
heaaklkl"
}

SubProgram "gles3 " {
Keywords { }
"!!GLES3"
}

}

#LINE 60

	}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 100
	
	Pass {
		Lighting Off
		SetTexture [_MainTex] {
			constantColor [_Color]
			Combine texture + constant
		}
	}
}
}