class SceneManager {
  private Scene activeScene;

  public Scene getScene() {
    return this.activeScene;
  }
  public void setScene(Scene s) {
    this.activeScene = s;
    s.setup();
  }
}

SceneManager man = new SceneManager();

public void setup()
{
  frameRate(60);
  size(512, 512);
  man.setScene(new DefaultScene());
}


public void draw()
{
  Scene s = man.getScene();
  s.draw();
}
