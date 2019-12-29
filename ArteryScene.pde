public class Artery {
  int n;
  float[] A;
  float[] Omega;
  float[] Theta;
  float[] Y;
  color col;
  float screenTheta;

  final int INTERVAL = 40;
  int OFFSET = 0;

  public Artery(int n, float theta, color col) {
    this.n = n;
    this.col = col;
    this.screenTheta = theta;

    A = new float[n];
    Omega = new float[n];
    Theta = new float[n];
    Y = new float[width + 400];

    for (int i = 0; i < n; i++) {
      A[i] = random(50);
      Omega[i] = random(0.01);
      Theta[i] = random(TWO_PI);
    }

    for (int i = -200; i < width + 200; i++) {
      float result = 0;
      for (int j = 0; j < n; j++) result += A[j] * sin((Omega[j] * i) + Theta[j]);
      Y[i + 200] = result;
    }
  }

  public void update(long dt) {
    OFFSET++;
    if (OFFSET >= INTERVAL) OFFSET -= INTERVAL;
  }

  public void draw(PGraphics image) {
    image.fill(col);
    image.rotate(screenTheta);
    for (int i =  -200 - (width/2) + OFFSET; i < 200 + (width/2); i += INTERVAL) image.ellipse(i, Y[i + 200 + width/2], 25, 25);
  }
}

public class ArteryScene implements Scene {

  PGraphics image;
  public PGraphics getImage() {
    return image;
  }

  color RAND_COLOR() {
    return color(random(120, 150), random(120, 150), random (120, 150));
  }

  Artery[] as;

  public ArteryScene(int n, int seed) {
    randomSeed(seed);
    image = createGraphics(width, height);
    as = new Artery[n];
    for (int i = 0; i < n; i++) as[i] = new Artery(30, random(TWO_PI), RAND_COLOR());
  }

  public void update(long dt) {
    for (int i = 0; i < as.length; i++) as[i].update(dt);
  }

  public void draw() {
    image.beginDraw();
    image.background(0);
    image.pushMatrix();
    image.noStroke();
    image.translate(width/2, height/2);
    for (int i = 0; i < as.length; i++) as[i].draw(image);
    image.popMatrix();
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
    return 9550;
  }
}
