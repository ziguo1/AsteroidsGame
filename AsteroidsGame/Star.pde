public class Star
{
  protected DefaultScene scene;
  protected int x, y;
  protected float size;
  protected final int MAX_SIZE = 3;
  protected final int MIN_SIZE = 1;

  protected final color refColor;
  protected color realColor;
  protected final float naturalTransparency;

  private float oscillationPeriod = 3000;
  private float phase = random(TWO_PI);

  public Star(int x, int y, DefaultScene scene) {
    this.x = x;
    this.y = y;
    this.size = (float) (Math.random() * (MAX_SIZE - MIN_SIZE)) + MIN_SIZE;
    this.scene = scene;

    {
      float closestDist = Float.MAX_VALUE;
      while (closestDist < (size * 11)) {
        this.x = (int) (Math.random() * width);
        this.y = (int) (Math.random() * height);

        closestDist = Float.MAX_VALUE;
        for (Star s : scene.getStars()) {
          if (s == this || s == null) continue;
          float dist = (float) Math.sqrt(Math.pow(s.x - x, 2) + Math.pow(s.y - y, 2));
          if (dist < closestDist) {
            closestDist = dist;
          }
        }
      }
    }
    this.naturalTransparency = (float) (Math.random() * 0.15F);
    this.refColor = lerpColor(color(146, 197, 213), color(210, 147, 134), (float) Math.random());
  }


  public void tick() {
    float current = millis();
    float oscillation = sin((current / oscillationPeriod) * TWO_PI + phase);
    float lerpAmount = map(oscillation, -1, 1, 0.1, 0.7);

    lerpAmount = constrain(lerpAmount + naturalTransparency, 0, 1);
    realColor = lerpColor(refColor, scene.framebufferColor, lerpAmount);
  }

  public void draw() {
    pushMatrix();
    translate(x, y);
    {
      color oc = g.fillColor;
      color strokeC = g.strokeColor;
      noStroke();

      fill(realColor);
      square(0, 0, size);

      final int glimmer = 10;
      for (int i = 0; i < glimmer; i++) {
        fill(lerpColor(realColor, scene.framebufferColor, ((float) i / glimmer)));

        square(size * (i / 2), 0, size);
        square(size * -(i / 2), 0, size);
        square(0, size * -(i / 2), size);
        square(0, size * (i / 2), size);

        if (i == 1) {
          square(size / 2F, size / 2F, size);
          square(-size / 2F, size / 2F, size);
          square(size / 2F, -size / 2F, size);
          square(-size / 2F, -size / 2F, size);
        }
      }

      stroke(strokeC);
      fill(oc);
    }
    popMatrix();
  }
}
