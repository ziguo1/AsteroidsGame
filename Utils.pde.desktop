import java.util.*;

// Pretty much all things "game engine" are
// located in this file. We store helper classes
// here to assist with game development.

public class SceneManager {
  private Scene activeScene;

  public Scene getScene() {
    return this.activeScene;
  }
  public void setScene(Scene s) {
    this.activeScene = s;
    s.setup();
  }
}

public static class UserInputManager {
  private static ArrayList<Character> heldKeys = new ArrayList<>();

  public static void keyDown(char c) {
    if (!heldKeys.contains((Character) c)) heldKeys.add((Character) c);
  }

  public static void keyUp(char c) {
    heldKeys.remove((Character) c);
  }

  public static boolean isKeyDown(char c) {
    return heldKeys.contains((Character) c);
  }

  public static int getHeldKeyAmount() {
    return heldKeys.size();
  }

  public static void clearHeldKeys() {
    heldKeys.clear();
  }

  public static ArrayList<Character> getHeldKeys() {
    return (ArrayList<Character>) heldKeys.clone();
  }
}

public static class DeferredTaskRunner {
  private static HashMap<Runnable, Long> tasks = new HashMap<>();

  public static void addTask(Runnable r, long delay) {
    tasks.put(r, (Long) (System.currentTimeMillis() + delay));
  }

  public static void flush() {
    tasks.clear(); // this might break some things
  }

  public static void runTasks() {
    for (Map.Entry<Runnable, Long> entry : tasks.entrySet()) {
      if (System.currentTimeMillis() >= entry.getValue()) {
        entry.getKey().run();
        tasks.remove(entry.getKey());
      }
    }
  }
}

public interface Scene {
  void setup();
  void draw();
}

public class Shaders {
  private ArrayList<Shader> pipeline;
  private ArrayList<Shader> basePipeline;

  public Shaders(ArrayList<Shader> basePipeline) {
    this.basePipeline = basePipeline;
    pipeline = new ArrayList(basePipeline);
  }

  public Shaders() {
    this.basePipeline = new ArrayList();
    pipeline = new ArrayList();
  }

  public void addShader(Shader s) {
    pipeline.add(s);
  }

  public void removeShader(Shader s) {
    pipeline.remove(s);
  }

  public void clear() {
    pipeline.clear();
  }

  public ArrayList<Shader> getPipeline() {
    return pipeline;
  }

  public void reset() {
    ArrayList<Shader> arr = new ArrayList();
    for (Shader shader : basePipeline) arr.add(shader);
    this.pipeline = arr;
  }

  public color[] process(color[] fb) {
    for (Shader s : pipeline) fb = s.processFramebuffer(fb);
    return fb;
  }
}

public interface Shader {
  color[] processFramebuffer(color[] fb);
}