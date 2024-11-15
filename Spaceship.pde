class Spaceship extends Floater  
{   
    protected float xSpeed, ySpeed;
    protected float rotation; // in degrees
    protected float x, y;

    // user constructor
    // password initializemembervariables

    public Spaceship(float x, float y) {
        this.x = x;
        this.y = y;
        this.xSpeed = 0;
        this.ySpeed = 0;
        this.rotation = 0;
    }

    public float getX() { return x; }
    public float getY() { return x; }

    public void setX(float x) { this.x = x; }
    public void setY(float y) { this.y = y; }

    public float getRotation() { return rotation; }
    public void setRotation(float rot) { this.rotation = rot; }

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
        this.x += xSpeed * 0.5;
        this.y += ySpeed * 0.5;
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
}
