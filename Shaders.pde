class MotionBlurShader implements Shader {
  protected color bg;
  protected float intensity;
  protected final float SNAP_TOL = 0.1;

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

class WarpEffectShader extends MotionBlurShader implements Shader {
  private long start;
  private long end;

  public WarpEffectShader(color bg, long duration) {
    super(bg, 1);
    this.start = System.currentTimeMillis();
    this.end = this.start + duration;
  }

  public color[] processFramebuffer(color[] fb) {
    this.intensity = 1 - (float) (System.currentTimeMillis() - this.start) / (float) (this.end - this.start);
    return super.processFramebuffer(fb);
  }
}
