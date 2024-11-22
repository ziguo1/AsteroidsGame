public class BaseBattleScene implements Scene {
  protected color framebufferColor;
  protected Shaders postShader;
  protected Shaders preShader;

  public BaseBattleScene() {
    this.framebufferColor = color(16);
    this.postShader = new Shaders();
    this.preShader = new Shaders();

    preShader.addShader(new MotionBlurShader(framebufferColor, 0.3));
    preShader.addShader(new VibranceShader(0.3));
  }

  void setup() {
    background(framebufferColor);
  }

  protected void drawPrimatives() {
    throw new UnsupportedOperationException("drawPrimatives() must be implemented by the subclass");
  }

  protected long begin = System.currentTimeMillis();
  void draw() {
    loadPixels();
    pixels = preShader.process(pixels);
    updatePixels();
    drawPrimatives();
    loadPixels();
    pixels = postShader.process(pixels);
    updatePixels();

    document.title = "Asteroids ::= " +
      (System.currentTimeMillis() - begin)
      + "ms/frame; " +
      (1000.0 / (System.currentTimeMillis() - begin)).toFixed(2)
      + " fps";
    begin = System.currentTimeMillis();
  }
}

public class DefaultScene extends BaseBattleScene implements Scene {
  private Spaceship ss;
  private Star[] stars;

  public DefaultScene() {
    super();
    this.ss = new Spaceship(height / 2, width / 2, 0.02, postShader);
    this.stars = new Star[100];

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star((int) random(width), (int) random(height));
    }
  }

  protected void drawPrimatives() {
    for (int i = 0; i < stars.length; i++) {
      stars[i].tick();
      stars[i].draw();
    }

    ss.processKeyboardInput();
    ss.tick();

    ss.draw();
  }
}
