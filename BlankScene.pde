public class BlankScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  public BlankScene() {
    image = createGraphics(width, height);
    image.beginDraw();
    image.background(0);
    image.endDraw();
  }

  public void update(long dt) {
  }

  public void draw() {
  }

  boolean preUpdate() { 
    return false;
  }
  float fadeInTime() { 
    return 0;
  }
  float fadeOutTime() { 
    return 0;
  }
  long length() { 
    return 4000;
  }
}
