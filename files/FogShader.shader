Shader "Olyxz16/FogShader"
{
    Properties
    {
        _MainTex("Texture",2D) = "white" {}
        _CameraDepthTexture("Texture",2D) = "white" {}
        _Color("FogColor", Color) = (1,1,1,1)
        _MinDist("MinDist", Float) = 0
        _MaxDist("MaxDist", Float) = 0
        _NearCameraClipPlane("NearClip", Float) = 0
        _FarCameraClipPlane("FarClip", Float) = 0
    }
    
    SubShader
    {

        Cull off Zwrite on

        Pass
		{

            CGPROGRAM
            #pragma vertex vert
			#pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CameraDepthNormalsTexture;
            float4 _Color;
            float _MinDist;
            float _MaxDist;
            float _NearCameraClipPlane;
            float _FarCameraClipPlane;
            
            float Clamp(float value, float min_val, float max_val) {
                if(value < min_val)
                    return min_val;
                else if(value > max_val)
                    return max_val;
                else return value;
            }
            float map(float value, float min1, float max1, float min2, float max2) {
                return Clamp(min2 + (value - min1) * (max2 - min2) / (max1 - min1), min2, max2);
            }
            float4 lerpColor(float4 col, float4 fog, float t) {
                return col+(fog-col)*t;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.uv);
                float4 NormalDepth;
                DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv), NormalDepth.w, NormalDepth.xyz);
                float depth = map(NormalDepth.w, 0,1, _NearCameraClipPlane, _FarCameraClipPlane);
                fixed4 col = lerp(tex, _Color, map(depth, _MinDist, _MaxDist, 0,_Color.a));
                return col;
            }	

            ENDCG
        }

    }
    FallBack "Diffuse"
}
