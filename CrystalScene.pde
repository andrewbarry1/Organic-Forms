public class Crystal {

  public float x;
  public float y;
  public float yDelay;
  public color col;

  public Crystal(float x, float y, float yDelay, color col) {
    this.x = x;
    this.yDelay = yDelay;
    this.y = yDelay + y;
    this.col = col;
  }
}

public class CrystalScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  Crystal[][] rows;
  boolean reuse = false;
  public void reuse() {
    reuse = true;
  }

  public CrystalScene() {
    image = createGraphics(width, height);

    rows = new Crystal[6][100];
    for (int r = 0; r < 6; r++) {
      int depth = 1080 + ((r-1) * 150);
      for (int x = 0; x < 100; x++) {
        rows[r][x] = new Crystal(x * (width+500) / 100f, depth, random(300), RAND_COLOR());
      }
    }
  }

  public void update(long dt) {
    for (int r = 0; r < rows.length; r++) {
      for (int x = 0; x < rows[r].length; x++) {
        if (rows[r][x].y > height - (300 * r) + rows[r][x].yDelay) rows[r][x].y -= (dt/1000f) * 25;
      }
    }
  }

  public void draw() {
    image.beginDraw();
    image.pushMatrix();
    image.translate(0, -100);
    image.rotate(PI/16f);
    image.noFill();
    image.strokeWeight(25);
    image.background(0);
    for (int r = rows.length - 1; r >= 0; r--) {
      for (int x = 0; x < rows[r].length; x++) {
        Crystal c = rows[r][x];
        image.stroke(c.col);
        float xShift = (r % 2 == 0) ? 12.5 : 0f;
        image.line(c.x + xShift, height + 50, c.x + xShift, c.y);
      }
    }
    image.popMatrix();
    image.endDraw();
  }

  boolean preUpdate() { 
    return true;
  }
  float fadeInTime() { 
    return 0;
  }
  float fadeOutTime() { 
    return 0;
  }
  long length() {
    if (reuse) return 18800;
    else return 19250;
  }
}
