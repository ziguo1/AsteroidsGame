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

void keyPressed() {
  UserInputManager.keyDown(key);
}

void keyReleased() {
  println("Key released: " + key);
  println(UserInputManager.getHeldKeyAmount());
  UserInputManager.keyUp(key);
}
