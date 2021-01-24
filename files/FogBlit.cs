using System.Collections;
using UnityEngine;

[ExecuteInEditMode]
public class FogBlit : MonoBehaviour
{

    public Material FogMaterial;

    void Start() {
        Camera.main.depthTextureMode = DepthTextureMode.DepthNormals;
        FogMaterial.SetFloat("_NearCameraClipPlane", Camera.main.nearClipPlane);
        FogMaterial.SetFloat("_FarCameraClipPlane", Camera.main.farClipPlane);
    }
    void OnRenderImage(RenderTexture src, RenderTexture dst) {
        if (FogMaterial != null)
            Graphics.Blit(src, dst, FogMaterial);
    }
}
