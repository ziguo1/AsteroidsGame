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
  final float SNAP_TOL = 0.1;

  public MotionBlurShader(color bg, float intensity) {
    this.bg = bg;
    this.intensity = constrain(1 - intensity, 0, 1);
  }

  public color[] processFramebuffer(color[] fb) {
    for (int i = 0; i < fb.length; i++) {
      color curr = fb[i];

      float r1 = red(curr);
      float g1 = green(curr);
      float b1 = blue(curr);
      float a1 = alpha(curr);

      float r2 = red(bg);
      float g2 = green(bg);
      float b2 = blue(bg);
      float a2 = alpha(bg);

      float colorDiff = abs(r1-r2) + abs(g1-g2) + abs(b1-b2) + abs(a1-a2);
      colorDiff /= (255 * 4);

      if (colorDiff < SNAP_TOL) {
        fb[i] = bg;
      } else {
        fb[i] = lerpColor(curr, bg, intensity);
      }
    }
    return fb;
  }
}
