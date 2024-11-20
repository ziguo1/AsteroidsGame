abstract class BaseBattleScene implements Scene {
  protected color framebufferColor;
  protected Shaders postShader;
  protected Shaders preShader;

  public BaseBattleScene() {
    this.framebufferColor = color(64);
    this.postShader = new Shaders();
    this.preShader = new Shaders();

    preShader.addShader(new MotionBlurShader(framebufferColor, 0.3));
    preShader.addShader(new VibranceShader(0.3));
  }

  void setup() {
    background(framebufferColor);
  }

  protected abstract void drawPrimatives();

  long begin = System.currentTimeMillis();
  void draw() {
    loadPixels();
    pixels = preShader.process(pixels);
    updatePixels();
    drawPrimatives();

    loadPixels();
    pixels = postShader.process(pixels);
    updatePixels();

    getSurface().setTitle(String.format("Asteroids ::= %.2f ms/frame; %.2f fps", (double) (System.currentTimeMillis() - begin), 1000.0 / (System.currentTimeMillis() - begin)));
    begin = System.currentTimeMillis();
  }
}

class DefaultScene extends BaseBattleScene implements Scene {
  private Spaceship ss;

  public DefaultScene() {
    super();
    this.ss = new Spaceship(height / 2, width / 2, 0.02, postShader);
  }

  protected void drawPrimatives() {
    ss.processKeyboardInput();
    ss.tick();
    ss.draw();
  }
}
