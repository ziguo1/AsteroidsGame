SceneManager man = new SceneManager();

public void setup()
{
  frameRate(60);
  size(512, 512);
  man.setScene(new DefaultScene());
}


public void draw()
{
  DeferredTaskRunner.runTasks();
  Scene s = man.getScene();
  s.draw();
}

void keyPressed() {
  UserInputManager.keyDown(key);
}

void keyReleased() {
  UserInputManager.keyUp(key);
}
