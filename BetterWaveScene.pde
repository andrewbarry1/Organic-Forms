public class Wave {

  float A;
  float Omega;
  float Theta;
  color col;
  PVector position;
  int length;
  int offset;

  public Wave(float A, float Omega, float Theta, color col, float x, float y, int l) {
    this.A = A;
    this.Omega = Omega;
    this.Theta = Theta;
    this.col = col;
    position = new PVector(x, y);
    this.length = l;
    offset = 0;
  }

  public void move(float x, float y) {
    position = position.add(x, y);
  }

  public void shift(float x) {
    offset += floor(x);
  }

  public void draw(PGraphics image) {
    float x = position.x + offset;
    float y = position.y;
    image.fill(col);
    for (int i = offset; i < offset + length; i++) {
      float fy = y + (A * sin((Omega * i) + Theta));
      image.ellipse(x, fy, 25, 25);
      x++;
    }
  }
}

public class BetterWaveScene implements Scene {

  Wave[] waves;
  PGraphics image;

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }


  public BetterWaveScene() {
    image = createGraphics(width, height);
    waves = new Wave[64];
    restart();
  }

  public void restart() {
    int i = 0;
    for (int y = 0; y < 8; y++) {
      int xOffset = (y % 2 == 0) ? 500 : 0;
      for (int x = 0; x < 8; x++) {
        waves[i++] = new Wave(35, 0.03, random(TWO_PI), RAND_COLOR(), (x * 1000) + xOffset, (y * 400), 500);
      }
    }
  }

  public void update(long dt) {
    for (int i = 0; i < waves.length; i++) {
      waves[i].shift(-2);
    }
  }

  public void draw() {
    image.beginDraw();
    image.noStroke();
    image.background(0);
    image.pushMatrix();
    image.translate(width/2, -height/2);
    image.rotate(PI/4);
    for (int i = 0; i < waves.length; i++) waves[i].draw(image);
    image.popMatrix();
    image.endDraw();
  }

  public PGraphics getImage() {
    return image;
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
    return 19250;
  }
}
