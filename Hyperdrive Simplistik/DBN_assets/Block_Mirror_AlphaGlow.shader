// Copyright 2013 DeathByNukes
// this is a rim light shader with an extra setting _Alpha to control what alpha value it writes to the screen buffer (NOT transparency)
// also does a different renderqueue

Shader "FG/Block_Mirror_AlphaGlow" {
Properties {
	_MainTex ("Base (RGB) (only used in the fallback shader)", 2D) = "black" {}
	_Color ("Block Color", Color) = (1,1,1,1)
	_AlphaGlowTint ("AlphaGlow Color Multiplier", Color) = (1,1,1,1)
	_BorderAdd ("Border Color Add (border = where UVs are 0,0)", Color) = (0.5,0.5,0.5,0)
	_BorderMult ("Border Color Multiplier (border = where UVs are 0,0)", Color) = (0.5,0.5,0.5,1)
	_RimColor ("Rim Color", Color) = (0.25,0.25,0.25,0.0)
	_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
}

SubShader {
	#LINE 62

	
	Pass {
		Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 38 to 38
//   d3d9 - ALU: 46 to 46
//   d3d11 - ALU: 17 to 17, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_Color]
Vector 12 [_AlphaGlowTint]
Vector 13 [_BorderAdd]
Vector 14 [_BorderMult]
Vector 15 [_RimColor]
Float 16 [_RimPower]
"!!ARBvp1.0
# 38 ALU
PARAM c[17] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
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
ADD R2.x, -R0, c[0];
MOV R1, c[13];
MOV R0, c[14];
MAD R0, R0, c[11], R1;
ABS R1.z, vertex.texcoord[0].y;
ABS R1.y, vertex.texcoord[0].x;
POW R1.x, R2.x, c[16].x;
SGE R1.z, c[0].y, R1;
SGE R1.y, c[0], R1;
MUL R2.x, R1.y, R1.z;
MUL R1, R1.x, c[15];
ABS R2.x, R2;
ADD R1, R1, c[11];
SGE R2.x, c[0].y, R2;
ADD R1, R1, -R0;
MAD R0, R1, R2.x, R0;
MIN R0, R0, c[0].x;
MAX R0, R0, c[0].y;
MUL result.color, R0, c[12];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 38 instructions, 3 R-regs
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
Vector 11 [_AlphaGlowTint]
Vector 12 [_BorderAdd]
Vector 13 [_BorderMult]
Vector 14 [_RimColor]
Float 15 [_RimPower]
"vs_2_0
; 46 ALU
def c16, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c8
mov r1.w, c16.y
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
min r0.x, r0, c16.y
max r2.x, r0, c16
mov r0, c10
mov r1, c12
mad r1, c13, r0, r1
add r2.x, -r2, c16.y
sge r0.y, c16.x, v2
sge r0.x, v2.y, c16
mul r0.z, r0.x, r0.y
sge r0.y, c16.x, v2.x
sge r0.x, v2, c16
mul r0.x, r0, r0.y
mul r2.y, r0.x, r0.z
pow r0, r2.x, c15.x
sge r0.z, c16.x, r2.y
sge r0.y, r2, c16.x
mul r0.y, r0, r0.z
max r0.y, -r0, r0
slt r2.x, c16, r0.y
mul r0, r0.x, c14
add r2.y, -r2.x, c16
mul r1, r2.y, r1
add r0, r0, c10
mad r0, r2.x, r0, r1
min r0, r0, c16.y
max r0, r0, c16.x
mul oD0, r0, c11
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
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Vector 16 [_Color] 4
Vector 32 [_AlphaGlowTint] 4
Vector 48 [_BorderAdd] 4
Vector 64 [_BorderMult] 4
Vector 80 [_RimColor] 4
Float 96 [_RimPower]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 27 instructions, 3 temp regs, 0 temp arrays:
// ALU 16 float, 0 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddifejapldinekbcooffpopoccamaeilbabaaaaaaoaaeaaaaadaaaaaa
cmaaaaaakaaaaaaapeaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaaedepemepfcaaklklfdeieefcoeadaaaaeaaaabaa
pjaaaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagiaaaaacadaaaaaadiaaaaai
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
agaaaaaabjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalpcaabaaa
aaaaaaaaegiocaaaaaaaaaaaafaaaaaaagaabaaaaaaaaaaaegiocaaaaaaaaaaa
abaaaaaabiaaaaakdcaabaaaabaaaaaaegbabaaaacaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaaabaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaa
akaabaaaabaaaaaadcaaaaampcaabaaaacaaaaaaegiocaaaaaaaaaaaabaaaaaa
egiocaaaaaaaaaaaaeaaaaaaegiocaaaaaaaaaaaadaaaaaadhcaaaajpcaabaaa
aaaaaaaaagaabaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaai
pccabaaaabaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab
"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 1 to 1, TEX: 0 to 0
//   d3d9 - ALU: 1 to 1
//   d3d11 - ALU: 0 to 0, TEX: 0 to 0, FLOW: 1 to 1
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

}

#LINE 70

	}
	Pass {
		Stencil {
			Ref 1
			ReadMask 1
			Comp Equal
		}
		Cull Front
		Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 40 to 40
//   d3d9 - ALU: 48 to 48
//   d3d11 - ALU: 18 to 18, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_Color]
Vector 12 [_AlphaGlowTint]
Vector 13 [_BorderAdd]
Vector 14 [_BorderMult]
Vector 15 [_RimColor]
Float 16 [_RimPower]
"!!ARBvp1.0
# 40 ALU
PARAM c[17] = { { 1.325, 1, 0 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
DP3 R2.x, vertex.normal, vertex.normal;
RSQ R2.x, R2.x;
MOV R0.xyz, c[9];
MOV R0.w, c[0].y;
MUL R2.xyz, R2.x, vertex.normal;
DP4 R1.z, R0, c[7];
DP4 R1.y, R0, c[6];
DP4 R1.x, R0, c[5];
MOV R0.xzw, vertex.position;
ADD R0.y, -vertex.position, -c[0].x;
MAD R1.xyz, R1, c[10].w, -R0;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, R1, R2;
MIN R1.x, R1, c[0].y;
MAX R1.x, R1, c[0].z;
ADD R1.x, -R1, c[0].y;
POW R1.x, R1.x, c[16].x;
MUL R1, R1.x, c[15];
ADD R3, R1, c[11];
ABS R2.y, vertex.texcoord[0];
ABS R2.x, vertex.texcoord[0];
SGE R2.y, c[0].z, R2;
SGE R2.x, c[0].z, R2;
MUL R4.x, R2, R2.y;
ABS R4.x, R4;
MOV R2, c[13];
MOV R1, c[14];
MAD R1, R1, c[11], R2;
SGE R4.x, c[0].z, R4;
ADD R2, R3, -R1;
MAD R1, R2, R4.x, R1;
MIN R1, R1, c[0].y;
MAX R1, R1, c[0].z;
MUL result.color, R1, c[12];
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
END
# 40 instructions, 5 R-regs
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
Vector 11 [_AlphaGlowTint]
Vector 12 [_BorderAdd]
Vector 13 [_BorderMult]
Vector 14 [_RimColor]
Float 15 [_RimPower]
"vs_2_0
; 48 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
def c16, -1.32500005, 0.00000000, 1.00000000, 0
dp3 r2.x, v1, v1
rsq r2.x, r2.x
mov r0.xyz, c8
mov r0.w, c16.z
mul r2.xyz, r2.x, v1
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
mov r0.xzw, v0
add r0.y, -v0, c16.x
mad r1.xyz, r1, c9.w, -r0
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, r1, r2
min r1.x, r1, c16.z
max r1.x, r1, c16.y
add r2.x, -r1, c16.z
pow r1, r2.x, c15.x
sge r1.z, c16.y, v2.y
sge r1.y, v2, c16
mul r1.w, r1.y, r1.z
sge r1.z, c16.y, v2.x
sge r1.y, v2.x, c16
mul r1.y, r1, r1.z
mul r1.y, r1, r1.w
sge r1.z, c16.y, r1.y
sge r1.y, r1, c16
mul r1.y, r1, r1.z
max r2.x, -r1.y, r1.y
slt r4.x, c16.y, r2
mul r1, r1.x, c14
mov r3, c12
mov r2, c10
mad r2, c13, r2, r3
add r3.x, -r4, c16.z
mul r2, r3.x, r2
add r1, r1, c10
mad r1, r4.x, r1, r2
min r1, r1, c16.z
max r1, r1, c16.y
mul oD0, r1, c11
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
dp4 oPos.x, r0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 112 // 100 used size, 7 vars
Vector 16 [_Color] 4
Vector 32 [_AlphaGlowTint] 4
Vector 48 [_BorderAdd] 4
Vector 64 [_BorderMult] 4
Vector 80 [_RimColor] 4
Float 96 [_RimPower]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 29 instructions, 3 temp regs, 0 temp arrays:
// ALU 17 float, 0 int, 1 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefieceddbmkbkenliaffnikcpaimfdkhaibcfjdabaaaaaadmafaaaaadaaaaaa
cmaaaaaakaaaaaaapeaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
adadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheoemaaaaaaacaaaaaaaiaaaaaadiaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaaeeaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaapaaaaaa
fdfgfpfaepfdejfeejepeoaaedepemepfcaaklklfdeieefceaaeaaaaeaaaabaa
baabaaaafjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaadpccabaaaabaaaaaagiaaaaacadaaaaaaaaaaaaai
bcaabaaaaaaaaaaabkbabaiaebaaaaaaaaaaaaaaabeaaaaajkjjkjlpdiaaaaai
pcaabaaaaaaaaaaaagaabaaaaaaaaaaaegiocaaaacaaaaaaabaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaacaaaaaakgbkbaaa
aaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaacaaaaaa
adaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaa
fgifcaaaabaaaaaaaeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaa
aaaaaaaaegiccaaaacaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaa
aaaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaa
abaaaaaaaeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegiccaaaacaaaaaabdaaaaaadcaaaaaphcaabaaaabaaaaaaegbcbaaa
aaaaaaaaaceaaaaaaaaaiadpaaaaialpaaaaiadpaaaaaaaaaceaaaaaaaaaaaaa
jkjjkjlpaaaaaaaaaaaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaacaaaaaabeaaaaaaegacbaiaebaaaaaaabaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaaabaaaaaaegbcbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegbcbaaaabaaaaaabacaaaahbcaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaabaaaaaaaaaaaaaibcaabaaaaaaaaaaaakaabaiaebaaaaaa
aaaaaaaaabeaaaaaaaaaiadpcpaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaa
diaaaaaibcaabaaaaaaaaaaaakaabaaaaaaaaaaaakiacaaaaaaaaaaaagaaaaaa
bjaaaaafbcaabaaaaaaaaaaaakaabaaaaaaaaaaadcaaaaalpcaabaaaaaaaaaaa
egiocaaaaaaaaaaaafaaaaaaagaabaaaaaaaaaaaegiocaaaaaaaaaaaabaaaaaa
biaaaaakdcaabaaaabaaaaaaegbabaaaacaaaaaaaceaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaabaaaaahbcaabaaaabaaaaaabkaabaaaabaaaaaaakaabaaa
abaaaaaadcaaaaampcaabaaaacaaaaaaegiocaaaaaaaaaaaabaaaaaaegiocaaa
aaaaaaaaaeaaaaaaegiocaaaaaaaaaaaadaaaaaadhcaaaajpcaabaaaaaaaaaaa
agaabaaaabaaaaaaegaobaaaacaaaaaaegaobaaaaaaaaaaadiaaaaaipccabaaa
abaaaaaaegaobaaaaaaaaaaaegiocaaaaaaaaaaaacaaaaaadoaaaaab"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 1 to 1, TEX: 0 to 0
//   d3d9 - ALU: 1 to 1
//   d3d11 - ALU: 0 to 0, TEX: 0 to 0, FLOW: 1 to 1
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

}

#LINE 86

	}
}
}
