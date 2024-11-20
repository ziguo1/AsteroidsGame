public class Star
{
  protected int x, y;
  protected float size;
  protected final int MAX_SIZE = 5;

  public Star(int x, int y) {
    this.x = x;
    this.y = y;
    this.size = (float) Math.random() * MAX_SIZE;
  }

  public void tick() {
    // heheheheheheheheehheheheehehehheeh
  }

  public void draw() {
    pushMatrix();
    translate(x, y);
    {
      circle(0, 0, size);
    }
    popMatrix();
  }
}
