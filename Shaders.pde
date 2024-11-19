class Shaders {
  ArrayList<Shader> pipeline;
  private ArrayList<Shader> basePipeline;

  public Shaders(ArrayList<Shader> basePipeline) {
    this.basePipeline = basePipeline;
    pipeline = new ArrayList(basePipeline);
  }

  public Shaders() {
    this.basePipeline = new ArrayList();
    pipeline = new ArrayList();
  }

  public void reset() {
    ArrayList<Shader> arr = new ArrayList();
    for (Shader shader : basePipeline) arr.add(shader);
    this.pipeline = arr;
  }

  public color[] process(color[] fb) {
    for (Shader s : pipeline) fb = s.processFramebuffer(fb);
    return fb;
  }
}

interface Shader {
  color[] processFramebuffer(color[] fb);
}

class MotionBlurShader implements Shader {
  color bg;
  float intensity;
  final int SNAP_TOL = 5;

  public MotionBlurShader(color bg, float intensity) {
    this.bg = bg;
    this.intensity = 1 - intensity;
  }

  public color[] processFramebuffer(color[] fb) {
    for (int i = 0; i < fb.length; i++) {
      final color calculatedColor = lerpColor(fb[i], this.bg, this.intensity);
      if (
        Math.abs((calculatedColor & 255) - (bg & 255)) <= SNAP_TOL
        || Math.abs(((calculatedColor >> 8) & 255) - ((bg >> 8) & 255)) <= SNAP_TOL
        || Math.abs(((calculatedColor >> 16) & 255) - ((bg >> 16) & 255)) <= SNAP_TOL
        || Math.abs(((calculatedColor >> 24) & 255) - ((bg >> 24) & 255)) <= SNAP_TOL
        ) fb[i] = bg;
      else fb[i] = calculatedColor;
    }
    return fb;
  }
}
