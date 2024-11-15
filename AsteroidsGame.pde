Spaceship ss = new Spaceship(256, 256);

public void setup() 
{
  size(512, 512);
  ss.setSpeed(10);
  ss.setSpeedRotation(75);
}


public void draw() 
{
  background(color(64));
  ss.setRotation(ss.getRotation() + 1);
  ss.tick();
  ss.draw();
}
