class Spaceship extends Floater
{
  public Spaceship(float x, float y) {
    super(x, y);
  }

  public Spaceship(float x, float y, float kineticFriction) {
    super(x, y, kineticFriction);
  }

  public void draw() {
    pushMatrix();
    translate(x, y);
    rotate(radians(rotation));
    {
      square(-5, -5, 10);
    }
    popMatrix();
  }

  final int MAX_SPEED = 10;

  public void processKeyboardInput() {
    float speed = this.getSpeed();
    boolean shouldAccelerate = Math.abs(speed) < MAX_SPEED;
    if (UserInputManager.isKeyDown('a')) {
      this.setRotation(this.getRotation() - 1);
      this.setSpeedRotation(this.getRotation() - 1);
    } else if (UserInputManager.isKeyDown('d')) {
      this.setRotation(this.getRotation() + 1);
      this.setSpeedRotation(this.getRotation() + 1);
    }

    if (UserInputManager.isKeyDown('w')) {
      if (shouldAccelerate) this.setSpeed(speed + 0.1f);
    } else if (UserInputManager.isKeyDown('s')) {
      if (speed > 0) this.setSpeed(speed - 0.1f);
    }
  }
}
