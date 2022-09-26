Shader "ku6ryo/TextureLineScroll"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Rows ("Number of rows", Range(0, 20)) = 4
        _StartPos ("Start position", Range(0, 20)) = 0
        _Length ("Length", Range(0, 20)) = 1
        _DisplayedLength ("Displayed length", Range(0, 20)) = 0.5
        _Speed ("Speed", Range(0, 10)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _StartPos;
        half _Length;
        half _DisplayedLength;
        half _Speed;
        half _Rows;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 uv = IN.uv_MainTex;
            half t = _Time.y;
            half x1D = _StartPos + (t * _Speed + _DisplayedLength * uv.x) % _Length;
            half x2D = frac(x1D);
            half y2D = (_Rows - floor(x1D) - 1) / _Rows + uv.y / _Rows;
            fixed4 c = tex2D (_MainTex, half2(x2D, y2D));
            o.Albedo = c.rgb;
            o.Metallic = 0;
            o.Smoothness = 0;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
