class Floater {
  protected float xSpeed, ySpeed;
  protected float rotation; // in degrees
  protected float kineticFriction;
  protected float x, y;

  public Floater(float x, float y) {
    this.x = x;
    this.y = y;
    this.xSpeed = 0;
    this.ySpeed = 0;
    this.rotation = 0;
    this.kineticFriction = 0;
  }

  public Floater(float x, float y, float kineticFriction) {
    this.x = x;
    this.y = y;
    this.xSpeed = 0;
    this.ySpeed = 0;
    this.rotation = 0;
    this.kineticFriction = Math.max(kineticFriction, 0);
  }

  public float getKineticFriction() {
    return 1 - kineticFriction;
  }
  public void setKineticFriction(float kine) {
    kineticFriction = 1 - kine;
  }

  public float getX() {
    return x;
  }
  public float getY() {
    return x;
  }

  public void setX(float x) {
    this.x = x;
  }
  public void setY(float y) {
    this.y = y;
  }

  public float getRotation() {
    return rotation;
  }
  public void setRotation(float rot) {
    this.rotation = rot;
  }

  public void setSpeedRotation(float deg) {
    float speed = getSpeed();
    this.xSpeed = speed * (float) Math.cos(radians(deg));
    this.ySpeed = speed * (float) Math.sin(radians(deg));
  }

  public void setSpeed(float speed) {
    float deg = getSpeedRotation();
    this.xSpeed = speed * (float) Math.cos(radians(deg));
    this.ySpeed = speed * (float) Math.sin(radians(deg));
  }

  public float getSpeed() {
    return (float) Math.sqrt(Math.pow(xSpeed, 2) + Math.pow(ySpeed, 2));
  }

  public float getSpeedRotation() {
    return (float) degrees((float) Math.atan2(ySpeed, xSpeed));
  }

  public void tick() {
    this.x += xSpeed;
    this.y += ySpeed;

    xSpeed *= (1 - kineticFriction);
    ySpeed *= (1 - kineticFriction);
  }

  public void draw() {
    throw new RuntimeException("This method has not been implemented!");
  }
}
