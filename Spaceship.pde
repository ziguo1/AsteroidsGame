public class Spaceship extends Floater
{
  protected Shaders shaderHook;

  public Spaceship(float x, float y, Shaders sh) {
    super(x, y);
    this.shaderHook = sh;
  }

  public Spaceship(float x, float y, float kineticFriction, Shaders sh) {
    super(x, y, kineticFriction);
    this.shaderHook = sh;
  }

  public void tick() {
    super.tick();

    if (x > width) x = 0;
    else if (x < 0) x = width;

    if (y > height) y = 0;
    else if (y < 0) y = height;
  }

  public void draw() {
    pushMatrix();
    translate(x, y);
    rotate(radians(rotation));
    {
      color s = g.strokeColor;
      noStroke();
      triangle(
        0, 10,
        0, -1,
        10, -1
        );
      triangle(
        0, -10,
        0, 1,
        10, 1
        );
      stroke(s);
    }
    popMatrix();
  }

  protected final int MAX_SPEED = 10;
  protected final float SPEED_INCREMENT = 0.1f;
  protected final float SLOW_DECREMENT = -0.05f;

  protected final double MAX_ROTATION_MOD = 5;
  protected final int ROTATION_INCREMENT = 2;
  protected final double ROTATION_INCREMENT_POW = 0.002;

  protected long lastHold = -1;
  protected long tillNextWarp = System.currentTimeMillis();
  protected char direction = 'n';

  public void processKeyboardInput() {
    float speed = this.getSpeed();
    boolean shouldAccelerate = Math.abs(speed) < MAX_SPEED;

    boolean turned = false;
    if (UserInputManager.isKeyDown('a')) {
      if (lastHold == -1 || direction != 'a') {
        lastHold = System.currentTimeMillis();
      }
      direction = 'a';
      turned = true;

      float timeFactor = (float) Math.min(Math.pow((System.currentTimeMillis() - lastHold) * 0.001, ROTATION_INCREMENT_POW), MAX_ROTATION_MOD);
      float rotationAmount = ROTATION_INCREMENT * timeFactor;
      this.rotation -= rotationAmount;
      this.setSpeedRotation(this.rotation);
    }
    if (UserInputManager.isKeyDown('d')) {
      if (lastHold == -1 || direction != 'd') {
        lastHold = System.currentTimeMillis();
      }
      direction = 'd';
      turned = true;

      float timeFactor = (float) Math.min(Math.pow((System.currentTimeMillis() - lastHold) * 0.001, ROTATION_INCREMENT_POW), MAX_ROTATION_MOD);
      float rotationAmount = ROTATION_INCREMENT * timeFactor;
      this.rotation += rotationAmount;
      this.setSpeedRotation(this.rotation);
    }
    if (!turned) {
      lastHold = -1;
      direction = 'n';
    }

    if (UserInputManager.isKeyDown('w')) {
      if (shouldAccelerate) this.setSpeed(speed + SPEED_INCREMENT);
    }
    if (UserInputManager.isKeyDown('s')) {
      if (speed > 0 || speed > -MAX_SPEED) this.setSpeed(speed + SLOW_DECREMENT);
    }

    if (UserInputManager.isKeyDown('e') && System.currentTimeMillis() > tillNextWarp) {
      tillNextWarp = System.currentTimeMillis() + 1000;
      float rotation = (float) (Math.random() * 360);
      this.setX((float) (Math.random() * width));
      this.setY((float) (Math.random() * height));
      this.setRotation(rotation);

      this.setSpeed(0);
      this.setSpeedRotation(rotation);

      WarpEffectShader warp = new WarpEffectShader(color(32, 64, 256), 1000);
      shaderHook.addShader(warp);
      DeferredTaskRunner.addTask(() -> shaderHook.removeShader(warp), 1000);
    }
  }
}
