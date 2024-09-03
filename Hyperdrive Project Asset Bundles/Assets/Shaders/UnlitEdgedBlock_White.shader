// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UnlitEdgedBlock_White" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,0.5)
		_MainTex ("Texture", 2D) = "white" { }
		_Brightness ("Brightness", Float) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		Pass {
			Fog {Mode Off}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _Color : COLOR;
			sampler2D _MainTex;

			struct appdata {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4  pos : SV_POSITION;
				float4  color : COLOR;
				float2  uv : TEXCOORD0;
			};

			float4 _MainTex_ST;
			float _Brightness;

			v2f vert (appdata v){
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}

			half4 frag (v2f i) : COLOR{
				half4 texcol = tex2D (_MainTex, i.uv);
				half outlineExtraBrightness = 1;
				half4 col = _Color + (1.0 - texcol.a)*_Color*.5 + (1.0 - texcol.a)*half4(outlineExtraBrightness, outlineExtraBrightness, outlineExtraBrightness, outlineExtraBrightness);
				return half4(col.xyz,1.0);
				//return texcol * _Color * i.color * _Brightness;
				//return texcol * _Color * _Brightness;
			}
			ENDCG
		}
	}
	Fallback "Vertex color unlit"
} 

