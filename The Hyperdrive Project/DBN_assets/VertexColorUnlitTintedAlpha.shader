Shader "VertexColorUnlitTintedAlpha" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _Color ("Tint", Color) = (1,1,1,1)
    }

    SubShader {
        Tags {"Queue" = "Transparent" }
		BindChannels {
			Bind "Vertex", vertex
			Bind "texcoord", texcoord
			Bind "Color", color
		} 
        Pass {
            ZWrite Off ColorMask RGB
            Blend SrcAlpha OneMinusSrcAlpha

            SetTexture [_MainTex] {
                Combine texture * primary
            }
            SetTexture [_MainTex] {
                constantColor [_Color]
                Combine previous * constant
            }
        }
    }
} 