public class MotionBlurShader implements Shader {
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

      float rDiff = abs(red(curr) - red(bg));
      float gDiff = abs(green(curr) - green(bg));
      float bDiff = abs(blue(curr) - blue(bg));
      float avgDiff = (rDiff + gDiff + bDiff) / (255.0 * 3);

      fb[i] = (avgDiff < SNAP_TOL) ? bg : lerpColor(curr, bg, intensity);
    }
    return fb;
  }
}

public class VibranceShader implements Shader {
  protected float intensity;

  public VibranceShader(float intensity) {
    this.intensity = constrain(intensity, 0, 1);
  }

  public color[] processFramebuffer(color[] fb) {
    for (int i = 0; i < fb.length; i++) {
      color curr = fb[i];
      float r = red(curr);
      float g = green(curr);
      float b = blue(curr);

      float avg = (r + g + b) / 3;
      float rDiff = r - avg;
      float gDiff = g - avg;
      float bDiff = b - avg;

      fb[i] = color(r + rDiff * intensity, g + gDiff * intensity, b + bDiff * intensity);
    }
    return fb;
  }
}

public class WarpEffectShader extends MotionBlurShader implements Shader {
  private long start;
  private long end;

  public WarpEffectShader(color bg, long duration) {
    super(bg, 1);
    this.start = System.currentTimeMillis();
    this.end = this.start + duration;
  }

  public color[] processFramebuffer(color[] fb) {
    this.intensity = 1 - Math.min((float) (System.currentTimeMillis() - this.start) / (float) (this.end - this.start), 1);
    return super.processFramebuffer(fb);
  }
}
