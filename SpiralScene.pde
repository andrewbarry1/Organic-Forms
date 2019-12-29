public class SpiralScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }
  
  float t;
  ArrayList<Integer> colors;

  public SpiralScene() {
    image = createGraphics(width, height);
    t = 0;
    colors = new ArrayList<Integer>();
    for (int i = 0; i < 500; i++) colors.add(RAND_COLOR());
  }
  
  
  public void update(long dt) {
    t += (dt / 1000f);
  }

  public void draw() {
    image.beginDraw();
    image.background(0);
    image.strokeWeight(25);
    float y = -300;
    int c = 0;
    while (y < height) {
      float wy = t + y; // y relative to window start
      float x = (width / 2) + (50 * sin(wy));
      float l = (width / 3) * sin(wy);
      image.stroke(colors.get(c++));
      image.line(x, wy * 10, x + l, wy * 10);
      y += 3;
    }
    image.endDraw();
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
    return 9600;
  }
}
