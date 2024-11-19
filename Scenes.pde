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
    this.ss = new Spaceship(height / 2, width / 2);

    shader.pipeline.add(new MotionBlurShader(framebufferColor, 0.5));
  }

  void setup() {
    background(color(64));
  }

  void draw() {
    loadPixels();
    pixels = shader.process(pixels);
    updatePixels();

    ss.processKeyboardInput();
    ss.tick();
    ss.draw();
  }
}
