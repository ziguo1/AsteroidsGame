interface Scene {
  void setup();
  void draw();
}

class DefaultScene implements Scene {
  color framebufferColor;
  Shaders shader;
  Spaceship ss;

  DefaultScene() {
    this.framebufferColor = color(64);
    this.shader = new Shaders();
    this.ss = new Spaceship(height / 2, width / 2, 0.02);

    shader.pipeline.add(new MotionBlurShader(framebufferColor, 0.3));
  }

  void setup() {
    background(color(64));
  }

  void draw() {
    long begin = System.currentTimeMillis();
    loadPixels();
    pixels = shader.process(pixels);
    updatePixels();
    float elapsedShader = System.currentTimeMillis() - begin;

    ss.processKeyboardInput();
    ss.tick();
    ss.draw();
    float elapsedFinal = System.currentTimeMillis() - begin;
    getSurface().setTitle(String.format("Asteroids ::= %.2fms (shader) | %.2fms (final)", elapsedShader, elapsedFinal));
  }
}
