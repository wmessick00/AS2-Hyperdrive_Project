Shader "block" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "black" { }
    }

    SubShader {
        Pass {
			Lighting Off
            SetTexture [_MainTex] {
                constantColor [_Color]
                Combine texture + constant
            }
        }
    }
} 