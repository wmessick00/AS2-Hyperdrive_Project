// 2013 DeathByNukes
Shader "FG/Wake" {
	Properties {
		_Colour ("Tint & Alpha", Color) = (1,1,1,1)
	}

	SubShader {
		BindChannels {
			Bind "Vertex", vertex
			Bind "Color", color
		} 
		Pass {
			Fog { Mode Off }
			ColorMask RGBA ZWrite Off
			Blend One OneMinusSrcColor, One Zero
			SetTexture [_MainTex] {
				constantColor [_Colour]
				Combine primary * constant, constant
			}
		}
	}
} 